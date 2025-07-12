module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p;       // propagate signals
    wire [7:0] g;       // generate signals
    wire [8:0] carry;   // carry chain with 9 bits (including Cin)

    assign p = a ^ b;
    assign g = a & b;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_chain
            // Carry-out for bit i = g[i] OR (p[i] AND carry[i])
            assign carry[i+1] = g[i] | (p[i] & carry[i]);
            // Sum bit i = p[i] XOR carry[i]
            assign sum[i] = p[i] ^ carry[i];
        end
    endgenerate

    assign Cout = carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Instantiate lower 8-bit adder
    adder_8bit lower (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(carry_mid)
    );

    // Instantiate upper 8-bit adder
    adder_8bit upper (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule