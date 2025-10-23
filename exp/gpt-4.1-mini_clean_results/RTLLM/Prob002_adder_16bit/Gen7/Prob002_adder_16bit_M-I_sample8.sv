module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [8:0] carry;

    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : adder_bits
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
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
    wire c1;

    adder_8bit u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c1)
    );

    adder_8bit u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule