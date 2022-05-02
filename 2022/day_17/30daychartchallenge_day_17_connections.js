const canvasSketch = require('canvas-sketch');
const random = require('canvas-sketch-util/random');
const math = require('canvas-sketch-util/math');
const settings = {
  dimensions: [ 1080, 1080 ],
  animate: true,
  //fps: 30
};

const sketch = () => {
  // Create dots
  const number_dots = 40
  const primary_colour = '#639104';
  const secondary_colour = '#910463';
  const group_dots = [];

  for (let i = 0; i < number_dots; i++){
    let x,y,colour
    x = random.range(10,1070);
    y = random.range(10,1070);
    const radius = 10;
    const velocity_magnitude = 1;
    if (random.boolean()==true){
      colour = primary_colour;
    } else {
      colour = secondary_colour;
    }
    group_dots.push(new Dot(x,y,radius, velocity_magnitude, colour)); 
  }
  return ({ context, width, height }) => {
    // - - - - - Background colour  - - - - -
    context.fillStyle = '#E2EBF2';
    context.fillRect(0, 0, width, height);
    // - - - - - - - - - - - - - - - - - - - -

    // Star: Draw lines between dots
    const criteria_line = 250;
    const min_width = 0.01;
    const max_width = 8;
    for (let i =0; i < group_dots.length; i++){
      let single_dot = group_dots[i];
      for (let j = i+1; j < group_dots.length; j++){
        let other_dot = group_dots[j];
        let distance_single_to_other = single_dot.pos.GetDistance(other_dot.pos);
        // Condition: draw line only to dots closer to each other
        if (distance_single_to_other > criteria_line) continue;
        // draw line
        context.beginPath();
        // closer points -> thicker line
        context.lineWidth = math.mapRange(distance_single_to_other,
                                          0, criteria_line,
                                          max_width, min_width
                                          );
        context.moveTo(single_dot.pos.x, single_dot.pos.y);
        context.lineTo(other_dot.pos.x, other_dot.pos.y);
        //context.strokeStyle = '#713900';
        context.stroke();
      }
    }

    // End: Draw lines between dots

    // Start: Draw dots
    group_dots.forEach(dot => {
      dot.update();
      dot.draw(context);
      dot.bounce_walls(width, height)
    })
    // End: Draw dots
  };
};

canvasSketch(sketch, settings);

// CLASSES
class DotPosition{
  constructor (x,y){
    this.x = x;
    this.y = y;
  }
  // Distance between points
  GetDistance(second_dot_position){
    const distance_x = this.x - second_dot_position.x;
    const distance_y = this.y - second_dot_position.y;
    const distance = Math.sqrt(distance_x*distance_x + distance_y*distance_y);
    return distance;
  }
}

class Dot{
  constructor (x,y,radius, velocity_magnitude, colour){
    this.pos = new DotPosition(x,y);
    this.radius = radius;
    // To animate: velocity
    this.velocity = new DotPosition(random.range(-velocity_magnitude,velocity_magnitude),
                                    random.range(-velocity_magnitude,velocity_magnitude));
    this.colour = colour;
    
  }
  // Method -> draw
  draw(context){
    context.beginPath();
    context.fillStyle = this.colour;
    context.arc(this.pos.x, this.pos.y, this.radius, 0, Math.PI * 2);
    context.fill();
  }
  // Update position
  update(){
    this.pos.x = this.pos.x + this.velocity.x;
    this.pos.y = this.pos.y + this.velocity.y;
  }
  // Make the dots bounce
  bounce_walls(width, height){
    if (this.pos.x <= 0 + this.radius || this.pos.x >= width - this.radius){
      this.velocity.x *= -1;
    }
    if (this.pos.y <= 0 + this.radius || this.pos.y >= height - this.radius){
      this.velocity.y *= -1;
    }
  }
}