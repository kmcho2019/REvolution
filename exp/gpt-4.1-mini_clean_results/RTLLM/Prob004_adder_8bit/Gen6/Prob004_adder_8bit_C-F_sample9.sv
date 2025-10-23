module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    // Gate-level full adder implementation
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             cin,
    output wire [WIDTH-1:0] sum,
    output wire             cout
);
    wire [WIDTH-2:0] carry; // internal carry chain between bits

    // LSB full adder (bit 0)
    bit_full_adder fa_lsb (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        // Middle bits (1 to WIDTH-2)
        for (i = 1; i < WIDTH-1; i = i + 1) begin : gen_fa_mid
            bit_full_adder fa_mid (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .sum(sum[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // MSB full adder (bit WIDTH-1)
    bit_full_adder fa_msb (
        .a(a[WIDTH-1]),
        .b(b[WIDTH-1]),
        .cin(carry[WIDTH-2]),
        .sum(sum[WIDTH-1]),
        .cout(cout)
    );

endmodule