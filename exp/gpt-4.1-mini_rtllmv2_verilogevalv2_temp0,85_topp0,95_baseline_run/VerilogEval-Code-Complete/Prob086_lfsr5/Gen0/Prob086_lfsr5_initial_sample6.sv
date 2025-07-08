module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

  always @(posedge clk) begin
    if (reset) begin
      q <= 5'b00001;
    end else begin
      // Calculate feedback as q[0] XOR q[2]
      wire feedback = q[0] ^ q[2];
      
      // Shift right with XOR taps for positions 5 (q[4]) and 3 (q[2])
      // q[4] <= q[3] XOR feedback
      // q[3] <= q[4]
      // q[2] <= q[1] XOR feedback
      // q[1] <= q[2]
      // q[0] <= q[1]
      q <= {q[3] ^ feedback, q[4], q[1] ^ feedback, q[2], q[1]};
    end
  end

endmodule