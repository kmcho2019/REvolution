module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [7:0] p, g;
    wire [7:0] carry;

    // Propagate and generate signals for each bit
    assign p = a ^ b;
    assign g = a & b;

    // Compute carry bits using ripple carry with propagate/generate
    // carry[0] is carry out from bit 0, which depends on Cin
    // carry[i] is carry out from bit i
    assign carry[0] = g[0] | (p[0] & Cin);

    genvar i;
    generate
        for (i = 1; i < 8; i = i + 1) begin : carry_gen
            assign carry[i] = g[i] | (p[i] & carry[i-1]);
        end
    endgenerate

    // Sum calculation: sum[i] = p[i] ^ carry_in_to_bit_i
    // carry_in_to_bit_0 is Cin, carry_in_to_bit_i is carry[i-1]
    assign sum[0] = p[0] ^ Cin;
    generate
        for (i = 1; i < 8; i = i + 1) begin : sum_gen
            assign sum[i] = p[i] ^ carry[i-1];
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
    wire c_mid;

    // Instantiate lower 8-bit adder
    adder_8bit u_adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Cout(c_mid)
    );

    // Instantiate upper 8-bit adder with carry from lower adder
    adder_8bit u_adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule