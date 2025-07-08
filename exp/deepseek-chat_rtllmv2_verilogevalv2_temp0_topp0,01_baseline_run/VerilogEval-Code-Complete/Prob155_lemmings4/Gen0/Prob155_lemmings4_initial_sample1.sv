module TopModule (
  input clk,
  input areset,
  input bump_left,
  input bump_right,
  input ground,
  input dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

  // Define states
  parameter WALK_LEFT = 3'b000;
  parameter WALK_RIGHT = 3'b001;
  parameter FALL = 3'b010;
  parameter DIG = 3'b011;
  parameter SPLATTER = 3'b100;

  reg [2:0] state, next_state;
  reg [4:0] fall_counter;
  reg prev_walk_left; // To remember walking direction before fall/dig

  // State transition logic
  always @(*) begin
    case (state)
      WALK_LEFT: begin
        if (~ground) next_state = FALL;
        else if (dig) next_state = DIG;
        else if (bump_left) next_state = WALK_RIGHT;
        else next_state = WALK_LEFT;
      end
      WALK_RIGHT: begin
        if (~ground) next_state = FALL;
        else if (dig) next_state = DIG;
        else if (bump_right) next_state = WALK_LEFT;
        else next_state = WALK_RIGHT;
      end
      DIG: begin
        if (~ground) next_state = FALL;
        else next_state = DIG;
      end
      FALL: begin
        if (ground) begin
          if (fall_counter > 20) next_state = SPLATTER;
          else next_state = prev_walk_left ? WALK_LEFT : WALK_RIGHT;
        end
        else next_state = FALL;
      end
      SPLATTER: next_state = SPLATTER;
      default: next_state = WALK_LEFT;
    endcase
  end

  // State register and fall counter
  always @(posedge clk, posedge areset) begin
    if (areset) begin
      state <= WALK_LEFT;
      fall_counter <= 0;
      prev_walk_left <= 1;
    end
    else begin
      state <= next_state;
      
      // Update fall counter
      if (state == FALL) begin
        if (~ground) fall_counter <= fall_counter + 1;
        else fall_counter <= 0;
      end
      else fall_counter <= 0;

      // Remember walking direction when entering fall/dig
      if ((state == WALK_LEFT || state == WALK_RIGHT) && 
          (next_state == FALL || next_state == DIG)) begin
        prev_walk_left <= (state == WALK_LEFT);
      end
    end
  end

  // Output logic (Moore machine)
  assign walk_left = (state == WALK_LEFT);
  assign walk_right = (state == WALK_RIGHT);
  assign aaah = (state == FALL);
  assign digging = (state == DIG);

endmodule