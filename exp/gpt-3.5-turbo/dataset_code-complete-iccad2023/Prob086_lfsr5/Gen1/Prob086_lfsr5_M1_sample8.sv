module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 5'b1; // initialize to 5'b1 on reset
    end else begin
      q <= {q[4] ^ q[2], q[4:1]}; // calculate new values based on taps at positions 5 and 3
    end
  end

endmodule