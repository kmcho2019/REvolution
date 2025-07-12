module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    wire [7:0] p, g;      // propagate and generate signals
    wire [8:0] c;         // carry signals, c[0] is initial carry-in (0)

    assign c[0] = 1'b0;

    // Generate propagate and generate for each bit
    assign p = a ^ b;     // propagate = a XOR b
    assign g = a & b;     // generate  = a AND b

    // Carry-lookahead: calculate carries using generate-for loop
    genvar i;
    generate
        for (i = 1; i <= 8; i = i + 1) begin : carry_gen
            assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
        end
    endgenerate

    // Sum bits = propagate XOR carry-in (sum = a XOR b XOR carry_in)
    assign s = p ^ c[7:0];

    // Overflow detection: carry-in to MSB XOR carry-out from MSB
    assign overflow = c[7] ^ c[8];

endmodule