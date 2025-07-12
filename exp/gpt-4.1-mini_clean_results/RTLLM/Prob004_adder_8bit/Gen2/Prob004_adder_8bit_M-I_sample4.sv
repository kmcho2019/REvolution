// Full adder module defined separately
module full_adder (
    input  wire x,
    input  wire y,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = x ^ y ^ cin;
    assign cout = (x & y) | (x & cin) | (y & cin);
endmodule

// 8-bit adder using generate loop with a carry vector of length 9
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [8:0] carry; // carry[0] = cin, carry[8] = cout

    assign carry[0] = cin;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : adder_bits
            full_adder fa (
                .x   (a[i]),
                .y   (b[i]),
                .cin (carry[i]),
                .sum (sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[8];

endmodule