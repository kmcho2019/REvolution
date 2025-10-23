module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;
    assign carry[0] = Cin;
    assign Co = carry[7];
    assign y[0] = a[0] ^ b[0] ^ Cin;
    genvar i;
    generate
        for (i = 1; i < 8; i++) begin
            assign carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            assign y[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    endgenerate
endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry;
    adder_8bit adder_lo(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry)
    );
    adder_8bit adder_hi(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule