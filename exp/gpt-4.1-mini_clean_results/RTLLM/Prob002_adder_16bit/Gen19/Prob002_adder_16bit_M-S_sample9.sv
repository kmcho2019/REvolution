module full_adder_1bit (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] carry; // internal carries
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : bit_adders
            full_adder_1bit fa (
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i]),
                .sum(y[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign Co = carry[8];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_8;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule