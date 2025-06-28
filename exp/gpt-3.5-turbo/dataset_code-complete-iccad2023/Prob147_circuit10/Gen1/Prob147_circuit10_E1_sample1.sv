module TopModule (
  input clk,
  input a,
  input b,
  output reg q,
  output reg state
);

reg d;

always @* begin
  case({a, b})
    2'b00: d = 1'b0; // When a and b are both 0, input D is 0
    2'b01: d = 1'b1; // When a is 0 and b is 1, input D is 1
    2'b10: d = 1'b1; // When a is 1 and b is 0, input D is 1
    2'b11: d = q;    // When both a and b are 1, input D is the current value of Q
  endcase
end

always @(posedge clk) begin
  q <= d;    // Assign the value of D to Q on every clock edge
  state <= q; // State signal is the current value of Q
end

endmodule