module EightBitParallelCLAAdder (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout,
    output       carry_into_msb // carry into bit 7 (MSB)
);
    wire [7:0] p; // propagate signals
    wire [7:0] g; // generate signals

    // Calculate bitwise propagate and generate
    assign p = a ^ b;
    assign g = a & b;

    // Compute carries in parallel by fully expanding carry expressions:
    // c[0] = cin
    // c[1] = g0 + p0*c0
    // c[2] = g1 + p1*g0 + p1*p0*c0
    // c[3] = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*c0
    // ...
    // and so on up to c[8]

    wire c0 = cin;

    wire c1 = g[0] | (p[0] & c0);

    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);

    wire c3 = g[2] 
              | (p[2] & g[1]) 
              | (p[2] & p[1] & g[0]) 
              | (p[2] & p[1] & p[0] & c0);

    wire c4 = g[3]
              | (p[3] & g[2])
              | (p[3] & p[2] & g[1])
              | (p[3] & p[2] & p[1] & g[0])
              | (p[3] & p[2] & p[1] & p[0] & c0);

    wire c5 = g[4]
              | (p[4] & g[3])
              | (p[4] & p[3] & g[2])
              | (p[4] & p[3] & p[2] & g[1])
              | (p[4] & p[3] & p[2] & p[1] & g[0])
              | (p[4] & p[3] & p[2] & p[1] & p[0] & c0);

    wire c6 = g[5]
              | (p[5] & g[4])
              | (p[5] & p[4] & g[3])
              | (p[5] & p[4] & p[3] & g[2])
              | (p[5] & p[4] & p[3] & p[2] & g[1])
              | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
              | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c0);

    wire c7 = g[6]
              | (p[6] & g[5])
              | (p[6] & p[5] & g[4])
              | (p[6] & p[5] & p[4] & g[3])
              | (p[6] & p[5] & p[4] & p[3] & g[2])
              | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
              | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
              | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c0);

    wire c8 = g[7]
              | (p[7] & g[6])
              | (p[7] & p[6] & g[5])
              | (p[7] & p[6] & p[5] & g[4])
              | (p[7] & p[6] & p[5] & p[4] & g[3])
              | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2])
              | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
              | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
              | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c0);

    // Assign sum bits: sum[i] = p[i] xor carry-in to bit i (c[i])
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;

    assign cout = c8;
    assign carry_into_msb = c7;
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire cout;
    wire carry_into_msb;

    EightBitParallelCLAAdder adder (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(s),
        .cout(cout),
        .carry_into_msb(carry_into_msb)
    );

    // Overflow occurs if carry into MSB != carry out of MSB
    assign overflow = carry_into_msb ^ cout;
endmodule