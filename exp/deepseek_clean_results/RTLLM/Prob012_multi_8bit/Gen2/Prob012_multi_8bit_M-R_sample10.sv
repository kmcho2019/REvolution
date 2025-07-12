module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Extend A to 16 bits for each possible shift position
    wire [15:0] A_ext = {8'b0, A};
    
    // Calculate partial products for each bit of B
    wire [15:0] pp0 = B[0] ? A_ext       : 16'b0;
    wire [15:0] pp1 = B[1] ? A_ext << 1  : 16'b0;
    wire [15:0] pp2 = B[2] ? A_ext << 2  : 16'b0;
    wire [15:0] pp3 = B[3] ? A_ext << 3  : 16'b0;
    wire [15:0] pp4 = B[4] ? A_ext << 4  : 16'b0;
    wire [15:0] pp5 = B[5] ? A_ext << 5  : 16'b0;
    wire [15:0] pp6 = B[6] ? A_ext << 6  : 16'b0;
    wire [15:0] pp7 = B[7] ? A_ext << 7  : 16'b0;
    
    // Sum all partial products
    assign product = pp0 + pp1 + pp2 + pp3 + pp4 + pp5 + pp6 + pp7;

endmodule