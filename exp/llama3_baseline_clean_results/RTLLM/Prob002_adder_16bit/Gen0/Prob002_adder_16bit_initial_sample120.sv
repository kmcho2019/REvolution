module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] sum;
    wire [7:0] carry;

    assign sum[0] = a[0] ^ b[0] ^ Cin;
    assign carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);

    generate
        for (genvar i = 1; i < 8; i++) begin
            assign sum[i] = a[i] ^ b[i] ^ carry[i-1];
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    assign y = sum;
    assign Co = carry[7];

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [7:0] sum_lower;
    wire carry_lower;
    wire [7:0] sum_upper;
    wire carry_upper;

    adder_8bit lower_adder(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_lower),
        .Co(carry_lower)
    );

    adder_8bit upper_adder(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_lower),
        .y(sum_upper),
        .Co(carry_upper)
    );

    assign y = {sum_upper, sum_lower};
    assign Co = carry_upper;

endmodule