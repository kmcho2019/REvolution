module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire [7:0] p, g;   // propagate and generate signals
wire [8:0] c;      // carry signals, with c[0] = 0 initial carry-in

assign c[0] = 1'b0;

// Propagate and generate signals for each bit
assign p = a ^ b;
assign g = a & b;

// Carry-lookahead calculation using generate-for loop
genvar i;
generate
    for (i = 1; i <= 8; i = i + 1) begin : carry_calc
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
endgenerate

// Sum bits = propagate XOR carry-in
assign s = p ^ c[7:0];

// Overflow detection: XOR of carry into and carry out of MSB (bit 7)
assign overflow = c[7] ^ c[8];

endmodule