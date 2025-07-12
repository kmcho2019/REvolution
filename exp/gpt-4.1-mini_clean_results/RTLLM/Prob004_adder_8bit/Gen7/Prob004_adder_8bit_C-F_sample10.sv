// Single bit full adder module
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

// Parameterized 4-bit ripple carry adder module using generate loop
module adder_4bit #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             cin,
    output wire [WIDTH-1:0] sum,
    output wire             cout
);
    wire [WIDTH:0] carry; // carry[0]=cin, carry[WIDTH]=cout
    assign carry[0] = cin;

    genvar i;
    generate
        for (i=0; i < WIDTH; i=i+1) begin : fa_gen
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[WIDTH];
endmodule

// Top-level 8-bit adder composed of two 4-bit adders
module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       cin,
    output wire [7:0] sum,
    output wire       cout
);
    wire carry_mid;

    adder_4bit #(.WIDTH(4)) lower_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .sum(sum[3:0]),
        .cout(carry_mid)
    );

    adder_4bit #(.WIDTH(4)) upper_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry_mid),
        .sum(sum[7:4]),
        .cout(cout)
    );
endmodule