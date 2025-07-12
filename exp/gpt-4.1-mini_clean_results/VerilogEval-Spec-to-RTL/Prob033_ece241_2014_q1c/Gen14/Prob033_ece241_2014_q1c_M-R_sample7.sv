module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p;    // propagate signals
    wire [7:0] g;    // generate signals
    wire [8:0] c;    // carry signals, c[0] = 0 initial carry-in

    assign p = a ^ b;    // propagate = a XOR b
    assign g = a & b;    // generate  = a AND b
    assign c[0] = 1'b0;  // initial carry-in

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: carry_loop
            // carry-out = generate OR (propagate AND carry-in)
            assign c[i+1] = g[i] | (p[i] & c[i]);
        end
    endgenerate

    // sum = propagate XOR carry-in
    assign s = p ^ c[7:0];

    // overflow = XOR of carry into and out of MSB (sign bit)
    assign overflow = c[7] ^ c[8];
endmodule