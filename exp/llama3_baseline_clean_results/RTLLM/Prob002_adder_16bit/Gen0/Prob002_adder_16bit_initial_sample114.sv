module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] carry;
    assign y[0] = a[0] ^ b[0] ^ Cin;
    assign Co = (a[7] & (b[7] | carry[6])) | (b[7] & carry[6]) | (carry[6] & a[7]);

    assign carry[0] = a[0] & b[0] | a[0] & Cin | b[0] & Cin;
    for(genvar i = 1; i < 8; i++) begin
        assign y[i] = a[i] ^ b[i] ^ carry[i-1];
        assign carry[i] = a[i] & b[i] | a[i] & carry[i-1] | b[i] & carry[i-1];
    end

    assign Co = carry[7];

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire carry_mid;

    adder_8bit adder_low(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit adder_high(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule