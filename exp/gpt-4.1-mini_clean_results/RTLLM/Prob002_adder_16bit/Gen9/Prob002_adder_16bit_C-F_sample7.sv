module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p;    // propagate
    wire [7:0] g;    // generate
    wire [8:0] c;    // carry signals

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_compute
            // Carry-out of bit i = g[i] | (p[i] & carry-in)
            assign c[i+1] = g[i] | (p[i] & c[i]);
            // Sum bit i = p[i] ^ carry-in
            assign sum[i] = p[i] ^ c[i];
        end
    endgenerate

    assign Cout = c[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Instantiate lower 8-bit carry-lookahead adder
    adder_8bit adder_lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    // Instantiate upper 8-bit carry-lookahead adder
    adder_8bit adder_upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule