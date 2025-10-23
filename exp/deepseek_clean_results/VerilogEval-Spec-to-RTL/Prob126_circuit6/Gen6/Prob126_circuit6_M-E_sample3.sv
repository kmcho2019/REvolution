module TopModule (
    input [2:0] a,
    output [15:0] q
);

wire [3:0] nibble0, nibble1, nibble2, nibble3;

// First nibble: (a ^ 3) rotated left by 1
assign nibble0 = {a[1:0] ^ 2'b11, a[2] ^ 1'b1};

// Second nibble: (a + 5) XOR 0xF
assign nibble1 = (a + 3'd5) ^ 4'hF;

// Third nibble: (a << 2) | (a >> 1)
assign nibble2 = {a[1:0], a[2:1]};

// Fourth nibble: (a * 3) + 2
assign nibble3 = (a * 2'd3) + 2'd2;

// Combine nibbles
assign q = {nibble0, nibble1, nibble2, nibble3};

endmodule