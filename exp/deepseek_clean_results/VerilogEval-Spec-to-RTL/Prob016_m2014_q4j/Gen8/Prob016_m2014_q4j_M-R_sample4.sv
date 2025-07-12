module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] axorb = x ^ y;
    wire [3:0] a_and_b = x & y;
    wire [4:0] carry;

    assign carry[0] = 1'b0;  // Initial carry-in
    
    // Bit 0
    assign sum[0] = axorb[0] ^ carry[0];
    assign carry[1] = a_and_b[0] | (axorb[0] & carry[0]);
    
    // Bit 1
    assign sum[1] = axorb[1] ^ carry[1];
    assign carry[2] = a_and_b[1] | (axorb[1] & carry[1]);
    
    // Bit 2
    assign sum[2] = axorb[2] ^ carry[2];
    assign carry[3] = a_and_b[2] | (axorb[2] & carry[2]);
    
    // Bit 3
    assign sum[3] = axorb[3] ^ carry[3];
    assign sum[4] = a_and_b[3] | (axorb[3] & carry[3]);  // Final carry-out
endmodule