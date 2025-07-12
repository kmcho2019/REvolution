module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [4:0] carry;  // 5 bits: carry[0] = Cin, carry[4] = final carry out

    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : bit_adder
            assign y[i] = a[i] ^ b[i] ^ carry[i];
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
        end
    endgenerate

    assign Co = carry[4];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1, c2, c3;

    // Instantiate four 4-bit adders, chaining carries
    adder_4bit u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c1)
    );

    adder_4bit u1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .y(y[7:4]),
        .Co(c2)
    );

    adder_4bit u2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .y(y[11:8]),
        .Co(c3)
    );

    adder_4bit u3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .y(y[15:12]),
        .Co(Co)
    );
endmodule