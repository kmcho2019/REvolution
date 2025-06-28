module TopModule (
  input clk,
  input reset,
  output reg [4:0] q
);

reg [4:0] next_q;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    q <= 5'b1; // Initialize LFSR output to 1 on reset
  end else begin
    next_q[0] <= q[4] ^ q[2] ^ q[0]; // Feedback from taps at bit positions 5 and 3
    next_q[1] <= q[0];
    next_q[2] <= q[1];
    next_q[3] <= q[2];
    next_q[4] <= q[3];
    
    // Shift the LFSR right: output LSB XOR with bit 3 and feedback XOR result
    q <= {next_q[4], next_q[0:3]}; 
  end
end

endmodule