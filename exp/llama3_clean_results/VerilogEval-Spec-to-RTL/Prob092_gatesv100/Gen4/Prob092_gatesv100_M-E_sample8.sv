module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Shift the input vector to the right for out_any calculation
wire [99:0] in_shifted_right;
assign in_shifted_right = {in[0], in[99:1]};

// Shift the input vector to the left for out_both calculation
wire [99:0] in_shifted_left;
assign in_shifted_left = {in[98:0], in[99]};

// Calculate out_both
assign out_both = (in & in_shifted_left) & ~(100'b1 << 99);

// Calculate out_any
assign out_any = (in | in_shifted_right) & ~(100'b1 << 0);

// Calculate out_different
assign out_different = ~(in ^ in_shifted_left);

endmodule