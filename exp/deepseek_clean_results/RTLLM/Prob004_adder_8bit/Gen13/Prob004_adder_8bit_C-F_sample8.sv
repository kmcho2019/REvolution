module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Parameter for future scalability (fixed to 8 for this implementation)
    localparam WIDTH = 8;
    
    // Carry chain - array style for clear propagation visualization
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    // Generate sum and carry for each bit
    // Using optimized carry equation: carry = (a & b) | (carry_in & (a ^ b))
    assign sum[0] = a[0] ^ b[0] ^ carry[0];
    assign carry[1] = (a[0] & b[0]) | (carry[0] & (a[0] ^ b[0]));

    assign sum[1] = a[1] ^ b[1] ^ carry[1];
    assign carry[2] = (a[1] & b[1]) | (carry[1] & (a[1] ^ b[1]));

    assign sum[2] = a[2] ^ b[2] ^ carry[2];
    assign carry[3] = (a[2] & b[2]) | (carry[2] & (a[2] ^ b[2]));

    assign sum[3] = a[3] ^ b[3] ^ carry[3];
    assign carry[4] = (a[3] & b[3]) | (carry[3] & (a[3] ^ b[3]));

    assign sum[4] = a[4] ^ b[4] ^ carry[4];
    assign carry[5] = (a[4] & b[4]) | (carry[4] & (a[4] ^ b[4]));

    assign sum[5] = a[5] ^ b[5] ^ carry[5];
    assign carry[6] = (a[5] & b[5]) | (carry[5] & (a[5] ^ b[5]));

    assign sum[6] = a[6] ^ b[6] ^ carry[6];
    assign carry[7] = (a[6] & b[6]) | (carry[6] & (a[6] ^ b[6]));

    assign sum[7] = a[7] ^ b[7] ^ carry[7];
    assign carry[8] = (a[7] & b[7]) | (carry[7] & (a[7] ^ b[7]));

    // Final carry out
    assign cout = carry[WIDTH];

endmodule