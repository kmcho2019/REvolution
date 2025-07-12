module FullAdder(
    input  a,
    input  b,
    output sum,
    output p,      // propagate = a ^ b
    output g       // generate = a & b
);
    assign p = a ^ b;
    assign g = a & b;
    // sum will be assigned after carry-in is known in TopModule
    // So sum here represents a preliminary sum without carry
    // In this refactor, sum output is preliminary sum bit (p)
    assign sum = p; // provisional; final sum = p ^ c_in will be assigned in TopModule
endmodule

module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p, g;
    wire [8:0] c;
    wire [7:0] prelim_sum;

    // Instantiate 8 FullAdders to compute propagate/generate and preliminary sum (p)
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin: fa_loop
            FullAdder fa (
                .a(a[i]),
                .b(b[i]),
                .p(p[i]),
                .g(g[i]),
                .sum(prelim_sum[i])
            );
        end
    endgenerate

    // Initial carry-in is zero
    assign c[0] = 1'b0;

    // Compute carries explicitly using carry-lookahead logic:
    // c[i+1] = g[i] | (p[i] & c[i])
    integer j;
    always @(*) begin
        c[0] = 1'b0;
        for (j=0; j<8; j=j+1) begin
            c[j+1] = g[j] | (p[j] & c[j]);
        end
    end

    // Compute final sum bits: s[i] = p[i] ^ c[i]
    generate
        for (i=0; i<8; i=i+1) begin: sum_assign
            assign s[i] = p[i] ^ c[i];
        end
    endgenerate

    // Overflow detection: XOR of carry-in and carry-out of MSB
    assign overflow = c[7] ^ c[8];
endmodule