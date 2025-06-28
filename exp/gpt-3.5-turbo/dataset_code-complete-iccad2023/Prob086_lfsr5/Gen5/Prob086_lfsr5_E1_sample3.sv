module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg feedback_5;
reg feedback_3;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1;
    feedback_5 <= 1'b1;
    feedback_3 <= 1'b1;
  end else begin
    feedback_5 <= q[4]; // Feedback from position 5
    feedback_3 <= q[2]; // Feedback from position 3
    
    q[0] <= feedback_5 ^ q[0] ^ q[2]; // XOR output of position 5, position 0, and position 2
    q[1] <= q[0];
    q[2] <= q[1];
    q[3] <= q[2];
    q[4] <= q[3];
  end
end

endmodule