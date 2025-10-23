module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output [3:0] q
);

// Build the LUT - each entry corresponds to a specific c value
wire [3:0] lut [0:3];
assign lut[0] = b;
assign lut[1] = e;
assign lut[2] = a;
assign lut[3] = d;

// Determine if c is a valid index (0-3)
wire valid_index = ~|c[3:2];  // c < 4

// Select between LUT output and default value
assign q = valid_index ? lut[c[1:0]] : 4'b1111;

endmodule