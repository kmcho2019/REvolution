module TopModule (
  input clk,
  input reset,
  output reg [3:0] q
);

  reg [3:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= 4'b0001; // Reset to 1
    end else begin
      case (state)
        4'b0001: state <= 4'b0010; // Transition from 1 to 2
        4'b0010: state <= 4'b0011; // Transition from 2 to 3
        4'b0011: state <= 4'b0100; // Transition from 3 to 4
        4'b0100: state <= 4'b0101; // Transition from 4 to 5
        4'b0101: state <= 4'b0110; // Transition from 5 to 6
        4'b0110: state <= 4'b0111; // Transition from 6 to 7
        4'b0111: state <= 4'b1000; // Transition from 7 to 8
        4'b1000: state <= 4'b1001; // Transition from 8 to 9
        4'b1001: state <= 4'b1010; // Transition from 9 to 10
        4'b1010: state <= 4'b0001; // Transition from 10 to 1
        default: state <= 4'b0001; // Default state
      endcase
    end

    q <= state; // Assign the current count state to the output
  end

endmodule