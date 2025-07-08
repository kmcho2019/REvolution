module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // Define states
  typedef enum logic [1:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D
  } state_t;

  state_t current_state, next_state;

  // Shift register for x pattern detection
  reg [2:0] x_shift;

  // Counter for y monitoring in state D
  reg [1:0] y_counter;

  // State machine
  always @(posedge clk) begin
    if (!resetn) begin
      current_state <= STATE_A;
      f <= 0;
      g <= 0;
      x_shift <= 3'b0;
      y_counter <= 2'b0;
    end else begin
      current_state <= next_state;
      
      // Shift x values
      x_shift <= {x_shift[1:0], x};

      case (current_state)
        STATE_A: begin
          f <= 0;
          g <= 0;
        end
        
        STATE_B: begin
          f <= 1;
          g <= 0;
        end
        
        STATE_C: begin
          f <= 0;
          if (x_shift == 3'b101) begin
            g <= 1;
          end else begin
            g <= 0;
          end
        end
        
        STATE_D: begin
          f <= 0;
          if (y_counter == 2'b10) begin
            // Two cycles passed without y=1
            g <= 0;
          end else if (y) begin
            // y=1 detected
            g <= 1;
          end
          
          // Increment counter if y not detected yet
          if (!y && y_counter < 2'b10) begin
            y_counter <= y_counter + 1;
          end
        end
      endcase
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      STATE_A: next_state = resetn ? STATE_B : STATE_A;
      STATE_B: next_state = STATE_C;
      STATE_C: next_state = (x_shift == 3'b101) ? STATE_D : STATE_C;
      STATE_D: next_state = STATE_D; // Stay in D permanently
      default: next_state = STATE_A;
    endcase
  end

endmodule