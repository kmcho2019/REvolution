// Bit-level full adder module with explicit propagate and generate signals
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire p, g;
    assign p = a ^ b;             // propagate
    assign g = a & b;             // generate
    assign sum = p ^ cin;         // sum bit
    assign cout = g | (p & cin);  // carry out
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

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adders
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(i == 0 ? cin : carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[7];

endmodule