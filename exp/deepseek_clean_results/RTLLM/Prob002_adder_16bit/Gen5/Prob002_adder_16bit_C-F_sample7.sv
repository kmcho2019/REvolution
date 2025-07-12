module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Combined approach: named carry vector for clarity and compactness
    wire [8:0] carry;
    assign carry[0] = cin;
    
    // Bit 0 - explicit operation with clear carry naming
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (a[0] & carry[0]) | (b[0] & carry[0]);
    
    // Bit 1
    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (a[1] & carry[1]) | (b[1] & carry[1]);
    
    // Bit 2
    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (a[2] & carry[2]) | (b[2] & carry[2]);
    
    // Bit 3
    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = (a[3] & b[3]) | (a[3] & carry[3]) | (b[3] & carry[3]);
    
    // Bit 4
    assign sum[4] = a[4] ^ b[4] ^ carry[4];
    assign carry[5] = (a[4] & b[4]) | (a[4] & carry[4]) | (b[4] & carry[4]);
    
    // Bit 5
    assign sum[5] = a[5] ^ b[5] ^ carry[5];
    assign carry[6] = (a[5] & b[5]) | (a[5] & carry[5]) | (b[5] & carry[5]);
    
    // Bit 6
    assign sum[6] = a[6] ^ b[6] ^ carry[6];
    assign carry[7] = (a[6] & b[6]) | (a[6] & carry[6]) | (b[6] & carry[6]);
    
    // Bit 7
    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    assign carry[8] = (a[7] & b[7]) | (a[7] & carry[7]) | (b[7] & carry[7]);
    
    assign cout = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    // Descriptive intermediate carry name
    wire carry_low_to_high;
    
    // Lower 8-bit adder (LSBs)
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cin),
        .sum(sum[7:0]),
        .cout(carry_low_to_high)
    );
    
    // Upper 8-bit adder (MSBs)
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_low_to_high),
        .sum(sum[15:8]),
        .cout(cout)
    );
endmodule