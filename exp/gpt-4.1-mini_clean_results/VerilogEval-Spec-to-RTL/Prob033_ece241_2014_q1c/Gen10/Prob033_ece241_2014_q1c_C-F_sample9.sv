module FullAdder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output p,      // propagate = a ^ b
    output g       // generate = a & b
);
    assign p = a ^ b;
    assign g = a & b;
    // sum = propagate ^ carry_in
    assign sum = p ^ cin;
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;
    wire [8:0] c;

    assign c[0] = 1'b0;  // initial carry-in

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin: fa_loop
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(s[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Carry-lookahead logic: c[i+1] = g[i] | (p[i] & c[i])
    generate
        for (i=0; i<8; i=i+1) begin: carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Overflow: XOR of carry-in and carry-out of MSB
    assign overflow = c[7] ^ c[8];
endmodule