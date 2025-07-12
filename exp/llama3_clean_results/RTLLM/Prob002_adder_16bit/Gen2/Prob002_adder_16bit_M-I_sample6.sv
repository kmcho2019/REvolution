// 1-bit full adder module
module adder_1bit(
    input  a,
    input  b,
    input  Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 8-bit full adder module using a ripple-carry approach
module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [6:0] c;

    adder_1bit u0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .y(y[0]),
       .Co(c[0])
    );

    generate
        for (genvar i = 1; i < 8; i++) begin
            adder_1bit u(
               .a(a[i]),
               .b(b[i]),
               .Cin(c[i-1]),
               .y(y[i]),
               .Co(c[i])
            );
        end
    endgenerate

    assign Co = c[7];
endmodule

// 16-bit full adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire        c8;
    wire  [7:0] y1, y2;

    adder_8bit u1(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y1),
       .Co(c8)
    );

    adder_8bit u2(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(c8),
       .y(y2),
       .Co(Co)
    );

    assign y = {y2, y1};
endmodule