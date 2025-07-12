module full_adder (
    input  wire a,
    input  wire b,
    input  wire Cin,
    output wire sum,
    output wire Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire       Cin,
    output wire [7:0] y,
    output wire       Co
);
    wire [7:0] c;  // Internal carry signals

    // Instantiate 8 full adders in a ripple carry chain
    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin),   .sum(y[0]), .Cout(c[0]));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(c[0]),  .sum(y[1]), .Cout(c[1]));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(c[1]),  .sum(y[2]), .Cout(c[2]));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(c[2]),  .sum(y[3]), .Cout(c[3]));
    full_adder fa4 (.a(a[4]), .b(b[4]), .Cin(c[3]),  .sum(y[4]), .Cout(c[4]));
    full_adder fa5 (.a(a[5]), .b(b[5]), .Cin(c[4]),  .sum(y[5]), .Cout(c[5]));
    full_adder fa6 (.a(a[6]), .b(b[6]), .Cin(c[5]),  .sum(y[6]), .Cout(c[6]));
    full_adder fa7 (.a(a[7]), .b(b[7]), .Cin(c[6]),  .sum(y[7]), .Cout(Co));
endmodule

module adder_16bit (
    input  wire [15:0] a,
    input  wire [15:0] b,
    input  wire        Cin,
    output wire [15:0] y,
    output wire        Co
);
    wire carry_mid;

    // Lower 8 bits addition
    adder_8bit adder_low (
        .a   (a[7:0]),
        .b   (b[7:0]),
        .Cin (Cin),
        .y   (y[7:0]),
        .Co  (carry_mid)
    );

    // Upper 8 bits addition
    adder_8bit adder_high (
        .a   (a[15:8]),
        .b   (b[15:8]),
        .Cin (carry_mid),
        .y   (y[15:8]),
        .Co  (Co)
    );
endmodule