module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] carry;

    // First full adder carry-in is Cin
    // carry[i] is carry-out from bit i
    full_adder fa0 (.a(a[0]), .b(b[0]), .cin(Cin),     .sum(sum[0]), .cout(carry[0]));
    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : fa_loop
            full_adder fa (.a(a[i]), .b(b[i]), .cin(carry[i-1]), .sum(sum[i]), .cout(carry[i]));
        end
    endgenerate

    assign Cout = carry[7];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule