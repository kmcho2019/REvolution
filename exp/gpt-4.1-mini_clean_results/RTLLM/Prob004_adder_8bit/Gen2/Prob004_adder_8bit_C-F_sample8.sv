// Bit-level full adder module using explicit generate and propagate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire p, g;
    assign p = a ^ b;          // propagate
    assign g = a & b;          // generate
    assign sum = p ^ cin;      // sum bit
    assign cout = g | (p & cin); // carry out
endmodule

// 8-bit ripple carry adder composed of 8 bit_full_adders instantiated via generate
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry; // internal carry signals

    // Instantiate the first full adder separately (carry-in is cin)
    bit_full_adder fa0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    // Instantiate remaining 7 full adders in a generate block
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : bit_adders
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // Final carry-out from MSB full adder
    assign cout = carry[7];

endmodule