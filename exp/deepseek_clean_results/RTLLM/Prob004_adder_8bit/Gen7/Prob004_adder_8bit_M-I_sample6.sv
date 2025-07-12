module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Internal carry chain
    wire [7:0] carry;

    // First bit optimized carry using MAJ3 function
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign carry[0] = (a[0] & b[0]) | (cin & (a[0] ^ b[0]));

    // Middle bits with optimized carry logic
    assign {sum[1], carry[1]} = {a[1] ^ b[1] ^ carry[0], (a[1] & b[1]) | (carry[0] & (a[1] ^ b[1]))};
    assign {sum[2], carry[2]} = {a[2] ^ b[2] ^ carry[1], (a[2] & b[2]) | (carry[1] & (a[2] ^ b[2]))};
    assign {sum[3], carry[3]} = {a[3] ^ b[3] ^ carry[2], (a[3] & b[3]) | (carry[2] & (a[3] ^ b[3]))};
    assign {sum[4], carry[4]} = {a[4] ^ b[4] ^ carry[3], (a[4] & b[4]) | (carry[3] & (a[4] ^ b[4]))};
    assign {sum[5], carry[5]} = {a[5] ^ b[5] ^ carry[4], (a[5] & b[5]) | (carry[4] & (a[5] ^ b[5]))};
    assign {sum[6], carry[6]} = {a[6] ^ b[6] ^ carry[5], (a[6] & b[6]) | (carry[5] & (a[6] ^ b[6]))};

    // Last bit with optimized cout generation
    assign sum[7] = a[7] ^ b[7] ^ carry[6];
    assign cout = (a[7] & b[7]) | (carry[6] & (a[7] ^ b[7]));

endmodule