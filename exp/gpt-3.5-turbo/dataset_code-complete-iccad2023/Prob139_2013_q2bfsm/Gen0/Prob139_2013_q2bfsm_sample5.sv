module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

  // State declaration
  reg [1:0] state, next_state;

  always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
      state <= 2'b00; // State A
    end else begin
      state <= next_state;
    end
  end

  // Output logic
  always @* begin
    case(state)
      2'b00: begin // State A
        f = 0; g = 0;
        if (resetn) begin
          next_state = 2'b01; // Transition to State B
        end
      end
      2'b01: begin // State B
        f = 1; g = 0;
        if (x == 1 && $past(x) == 0 && $past($past(x)) == 1) begin
          next_state = 2'b10; // Transition to State C
        end else begin
          next_state = 2'b01; // Stay in State B
        end
      end
      2'b10: begin // State C
        f = 0; g = 1;
        if (y == 1 && $past(y) == 0) begin
          g = 1; // Permanent g = 1
          next_state = 2'b10; // Stay in State C
        end else begin
          g = 0; // Permanent g = 0
          next_state = 2'b10; // Stay in State C
        end
      end
    endcase
  end

endmodule