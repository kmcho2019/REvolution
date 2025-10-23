module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] gray_count;
wire [3:0] next_gray;

// Gray code sequence for 0-9
assign next_gray = reset ? 4'b0000 : 
                  (gray_count == 4'b0000) ? 4'b0001 :
                  (gray_count == 4'b0001) ? 4'b0011 :
                  (gray_count == 4'b0011) ? 4'b0010 :
                  (gray_count == 4'b0010) ? 4'b0110 :
                  (gray_count == 4'b0110) ? 4'b0111 :
                  (gray_count == 4'b0111) ? 4'b0101 :
                  (gray_count == 4'b0101) ? 4'b0100 :
                  (gray_count == 4'b0100) ? 4'b1100 :
                  (gray_count == 4'b1100) ? 4'b1101 :
                  (gray_count == 4'b1101) ? 4'b0000 : 4'b0000;

always @(posedge clk) begin
    gray_count <= next_gray;
end

// Convert Gray code back to binary for output
assign q[3] = gray_count[3];
assign q[2] = gray_count[3] ^ gray_count[2];
assign q[1] = gray_count[3] ^ gray_count[2] ^ gray_count[1];
assign q[0] = gray_count[3] ^ gray_count[2] ^ gray_count[1] ^ gray_count[0];

endmodule