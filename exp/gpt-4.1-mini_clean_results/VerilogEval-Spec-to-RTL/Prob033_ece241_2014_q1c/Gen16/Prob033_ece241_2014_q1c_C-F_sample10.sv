module EightBitCLAAdder (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       carry_into_msb,
    output       cout
);
    wire [7:0] p, g;
    wire [8:0] c;

    assign p = a ^ b;    // Propagate
    assign g = a & b;    // Generate

    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum = p ^ c[7:0];
    assign carry_into_msb = c[7];
    assign cout = c[8];
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire carry_into_msb;
    wire cout;

    EightBitCLAAdder adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .carry_into_msb(carry_into_msb),
        .cout(cout)
    );

    // Overflow occurs when carry into MSB differs from carry out of MSB
    assign overflow = carry_into_msb ^ cout;

endmodule