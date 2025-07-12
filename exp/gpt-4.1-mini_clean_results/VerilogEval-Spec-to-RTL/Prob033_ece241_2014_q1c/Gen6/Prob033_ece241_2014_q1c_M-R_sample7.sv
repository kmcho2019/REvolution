module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

wire [7:0] p, g;   // propagate and generate
wire [8:0] c;      // carry signals, c[0] = 0 carry-in

assign c[0] = 1'b0;

// Generate propagate and generate signals
assign p = a ^ b;  // propagate = a xor b
assign g = a & b;  // generate = a and b

genvar i;
generate
    for (i = 1; i <= 8; i = i + 1) begin : carry_calc
        assign c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
endgenerate

// Sum bits = propagate xor carry-in
assign s = p ^ c[7:0];

// Overflow for signed addition:
// overflow = carry into MSB xor carry out of MSB
assign overflow = c[7] ^ c[8];

endmodule