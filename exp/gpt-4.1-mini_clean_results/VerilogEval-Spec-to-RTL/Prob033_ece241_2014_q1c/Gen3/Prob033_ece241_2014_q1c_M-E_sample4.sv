module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Sign-extend inputs from 8 to 9 bits
    wire [8:0] a_ext = {a[7], a};
    wire [8:0] b_ext = {b[7], b};

    // Perform 9-bit addition
    wire [8:0] sum = a_ext + b_ext;

    assign s = sum[7:0];

    // Overflow occurs if carry into MSB != carry out of MSB
    wire carry_into_msb = (a_ext[7] & b_ext[7]) | (a_ext[7] & ~sum[7]) | (b_ext[7] & ~sum[7]);
    wire carry_out_msb = sum[8];

    assign overflow = carry_into_msb ^ carry_out_msb;

endmodule