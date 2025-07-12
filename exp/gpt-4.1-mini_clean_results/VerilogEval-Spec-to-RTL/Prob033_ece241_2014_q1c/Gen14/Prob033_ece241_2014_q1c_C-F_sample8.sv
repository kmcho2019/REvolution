module EightBitCLAAdder (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb
);
    wire [7:0] p;    // propagate signals
    wire [7:0] g;    // generate signals
    wire [8:0] c;    // carry signals: c[0]=cin, c[8]=cout

    assign p = a ^ b;
    assign g = a & b;
    assign c[0] = cin;

    // Compute carries using carry-lookahead logic:
    // c[i+1] = g[i] | (p[i] & c[i])
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_calc
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    assign sum = p ^ c[7:0];
    assign cout = c[8];
    assign carry_into_msb = c[7];  // carry into bit 7 (MSB)
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout, carry_into_msb;

    EightBitCLAAdder adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Overflow detection for signed addition: carry into MSB XOR carry out of MSB
    assign overflow = carry_into_msb ^ cout;
endmodule