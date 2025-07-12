module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire [7:0] carry; // internal carry wires between adders

    // bit 0 full adder
    full_adder fa0 (
        .a    (a[0]),
        .b    (b[0]),
        .cin  (cin),
        .sum  (sum[0]),
        .cout (carry[0])
    );

    // bits 1 to 6 full adders
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : gen_full_adders
            full_adder fa (
                .a    (a[i]),
                .b    (b[i]),
                .cin  (carry[i-1]),
                .sum  (sum[i]),
                .cout (carry[i])
            );
        end
    endgenerate

    assign cout = carry[7];

endmodule