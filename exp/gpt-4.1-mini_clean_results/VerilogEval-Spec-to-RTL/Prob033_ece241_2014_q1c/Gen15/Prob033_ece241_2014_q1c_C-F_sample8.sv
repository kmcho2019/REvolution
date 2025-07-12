module FullAdder(
    input  a,
    input  b,
    output p,      // propagate = a ^ b
    output g       // generate = a & b
);
    assign p = a ^ b;
    assign g = a & b;
endmodule

module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p;
    wire [7:0] g;
    wire [8:0] c; // carry signals: c[0] = carry-in = 0

    assign c[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: FA_GEN
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .p(p[i]),
                .g(g[i])
            );
        end
    endgenerate

    // Carry chain calculation function with carry-lookahead logic
    function [8:0] carry_chain;
        input [7:0] p_in;
        input [7:0] g_in;
        input       cin_in;
        integer j;
        reg [8:0] carry_tmp;
        begin
            carry_tmp[0] = cin_in;
            for (j = 0; j < 8; j = j + 1) begin
                carry_tmp[j+1] = g_in[j] | (p_in[j] & carry_tmp[j]);
            end
            carry_chain = carry_tmp;
        end
    endfunction

    // Compute all carries once
    assign c = carry_chain(p, g, 1'b0);

    // Sum bits: s[i] = p[i] ^ carry-in to bit i
    assign s = p ^ c[7:0];

    // Overflow detection: XOR of carry into MSB and carry out of MSB
    assign overflow = c[7] ^ c[8];

endmodule