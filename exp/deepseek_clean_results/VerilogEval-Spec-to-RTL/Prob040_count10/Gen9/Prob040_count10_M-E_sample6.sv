module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] gray_state;

// Gray code sequence for 0-9
wire [3:0] next_gray = reset ? 4'b0000 : 
                      (gray_state == 4'b1100) ? 4'b0000 :  // After 9 (1001) comes 0 (0000)
                      (gray_state == 4'b0000) ? 4'b0001 :
                      (gray_state == 4'b0001) ? 4'b0011 :
                      (gray_state == 4'b0011) ? 4'b0010 :
                      (gray_state == 4'b0010) ? 4'b0110 :
                      (gray_state == 4'b0110) ? 4'b0111 :
                      (gray_state == 4'b0111) ? 4'b0101 :
                      (gray_state == 4'b0101) ? 4'b0100 :
                      (gray_state == 4'b0100) ? 4'b1100 :
                      (gray_state == 4'b1100) ? 4'b0000 :  // Redundant but complete
                      (gray_state == 4'b1000) ? 4'b1001 :
                      4'b1000;  // Default case (shouldn't occur)

// Gray to binary conversion
assign q[3] = gray_state[3];
assign q[2] = gray_state[3] ^ gray_state[2];
assign q[1] = gray_state[3] ^ gray_state[2] ^ gray_state[1];
assign q[0] = gray_state[3] ^ gray_state[2] ^ gray_state[1] ^ gray_state[0];

always @(posedge clk) begin
    gray_state <= next_gray;
end

endmodule