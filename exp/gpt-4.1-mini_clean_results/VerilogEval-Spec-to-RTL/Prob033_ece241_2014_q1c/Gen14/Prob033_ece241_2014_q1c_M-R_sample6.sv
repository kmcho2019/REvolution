module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);
    wire [7:0] p; // propagate signals: a ^ b
    wire [7:0] g; // generate signals: a & b
    reg  [8:0] c; // carry signals

    // Compute propagate and generate vectors
    assign p = a ^ b;
    assign g = a & b;

    integer i;
    always @(*) begin
        c[0] = 1'b0; // initial carry-in
        // Carry-lookahead: c[i+1] = g[i] | (p[i] & c[i])
        for (i = 0; i < 8; i = i + 1) begin
            c[i+1] = g[i] | (p[i] & c[i]);
        end
    end

    // Sum bits: s[i] = p[i] ^ carry-in
    assign s = p ^ c[7:0];

    // Overflow detection: XOR of carry in and carry out of MSB
    assign overflow = c[7] ^ c[8];
endmodule