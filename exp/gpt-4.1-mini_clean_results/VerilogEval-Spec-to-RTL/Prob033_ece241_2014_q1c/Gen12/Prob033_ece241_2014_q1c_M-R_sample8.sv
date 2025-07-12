module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] p;       // propagate signals
    wire [7:0] g;       // generate signals
    wire [8:0] c;       // carry signals

    assign c[0] = 1'b0;

    // Directly compute propagate and generate signals
    assign p = a ^ b;
    assign g = a & b;

    // Carry-lookahead computation: c[i+1] = g[i] | (p[i] & c[i])
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : carry_loop
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // Sum bits: sum[i] = p[i] ^ c[i]
    assign s = p ^ c[7:0];

    // Overflow detection: XOR of carry-in and carry-out of MSB
    assign overflow = c[7] ^ c[8];

endmodule