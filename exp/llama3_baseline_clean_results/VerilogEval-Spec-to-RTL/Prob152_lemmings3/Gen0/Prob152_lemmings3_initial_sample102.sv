module TopModule (
  input  clk,
  input  areset,
  input  bump_left,
  input  bump_right,
  input  ground,
  input  dig,
  output walk_left,
  output walk_right,
  output aaah,
  output digging
);

  // State encoding
  parameter WALKING_LEFT = 2'b00;
  parameter WALKING_RIGHT = 2'b01;
  parameter FALLING = 2'b10;
  parameter DIGGING = 2'b11;

  reg [1:0] current_state, next_state;

  // Output logic
  always @(current_state) begin
    case (current_state)
      WALKING_LEFT: begin
        walk_left = 1'b1;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;
      end
      WALKING_RIGHT: begin
        walk_left = 1'b0;
        walk_right = 1'b1;
        aaah = 1'b0;
        digging = 1'b0;
      end
      FALLING: begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b1;
        digging = 1'b0;
      end
      default: // DIGGING
      begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b1;
      end
    endcase
  end

  // Next state logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= WALKING_LEFT;
    end else begin
      case (current_state)
        WALKING_LEFT: begin
          if (ground == 1'b0) begin
            current_state <= FALLING;
          end else if (dig == 1'b1) begin
            current_state <= DIGGING;
          end else if (bump_left == 1'b1) begin
            current_state <= WALKING_RIGHT;
          end else if (bump_right == 1'b1) begin
            current_state <= WALKING_LEFT;
          end else begin
            current_state <= WALKING_LEFT;
          end
        end
        WALKING_RIGHT: begin
          if (ground == 1'b0) begin
            current_state <= FALLING;
          end else if (dig == 1'b1) begin
            current_state <= DIGGING;
          end else if (bump_right == 1'b1) begin
            current_state <= WALKING_LEFT;
          end else if (bump_left == 1'b1) begin
            current_state <= WALKING_RIGHT;
          end else begin
            current_state <= WALKING_RIGHT;
          end
        end
        FALLING: begin
          if (ground == 1'b1) begin
            current_state <= WALKING_LEFT; // Return to original direction, assume left for simplicity
          end else begin
            current_state <= FALLING;
          end
        end
        default: // DIGGING
        begin
          if (ground == 1'b0) begin
            current_state <= FALLING;
          end else begin
            current_state <= DIGGING;
          end
        end
      endcase
    end
  end

endmodule