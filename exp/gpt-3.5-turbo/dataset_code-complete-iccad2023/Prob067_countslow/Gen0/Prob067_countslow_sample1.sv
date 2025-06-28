module TopModule (
  input clk,
  input slowena,
  input reset,
  output reg [3:0] q
);

  // Define states for the state machine
  reg [1:0] state;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 4'b0000; // Reset counter
      state <= 2'b00; // Reset to initial state
    end else begin
      // State machine to control the counter
      case (state)
        2'b00: begin // State 0 - checking slowena
          if (slowena) begin
            q <= q + 1; // Increment counter
            state <= 2'b01; // Move to next state
          end
        end
        2'b01: begin // State 1 - incrementing
          state <= 2'b00; // Move back to state 0
        end
      endcase
    end
  end
endmodule