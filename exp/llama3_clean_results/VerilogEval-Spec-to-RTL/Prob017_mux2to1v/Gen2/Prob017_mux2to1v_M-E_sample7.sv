module TopModule(
    input [99:0] a,  // 100 bits
    input [99:0] b,  // 100 bits
    input sel,
    output [99:0] out // 100 bits
);

wire [99:0] mask_a;
wire [99:0] mask_b;

// Generate masks based on the select line
assign mask_a = ~sel ? {100{1'b1}} : {100{1'b0}};
assign mask_b = sel ? {100{1'b1}} : {100{1'b0}};

// Apply masks to inputs and combine using bitwise OR
assign out = (a & mask_a) | (b & mask_b);

endmodule