module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// Define the states
parameter A = 2'b00;  // Beginning state
parameter B = 2'b01;  // State after f = 1 for 1 clock cycle
parameter C = 2'b10;  // State after x has values 1, 0, 1
parameter D = 2'b11;  // State after y transitions

// Define flip-flops for state and previous x
reg [1:0] state, prev_x;

always @ (posedge clk or negedge resetn) begin
  if (~resetn) begin
    state <= A;        // Initialize to state A
    prev_x <= 2'b00;   // Initialize to 0
    f <= 0;            // Set f to 0
    g <= 0;            // Set g to 0
  end
  else begin
    case(state)
      A: begin
        f <= 1;        // Set f to 1 for 1 clock cycle
        state <= B;    // Transition to state B
      end
      B: begin
        if (x == 1 && prev_x == 0) begin
          state <= C;  // Transition to state C
        end
        else begin
          prev_x <= x; // Update previous x
        end
      end
      C: begin
        if (x == 1 && prev_x == 0) begin
          g <= 1;     // Set g to 1
          state <= D; // Transition to state D
        end
        else begin
          prev_x <= x; // Update previous x
        end
      end
      D: begin
        if (y == 1) begin
          g <= 1;  // Set g to 1 permanently
        end
        else begin
          g <= 0;  // Set g to 0 permanently
        end
      end
    endcase
  end
end

endmodule