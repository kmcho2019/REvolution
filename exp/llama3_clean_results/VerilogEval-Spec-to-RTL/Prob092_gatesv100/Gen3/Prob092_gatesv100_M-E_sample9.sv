module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

// Shift input vector to the left and right for efficient comparisons
wire [99:0] in_shift_left;
wire [99:0] in_shift_right;

// Shift in to the left by one bit
assign in_shift_left = {in[98:0], 1'b0};

// Shift in to the right by one bit, wrapping around for the last bit
assign in_shift_right = {1'b0, in[99:1]};

// Perform bitwise operations for each output
genvar i;
generate
    for (i = 0; i < 100; i++) begin
        assign out_both[i] = in[i] && in_shift_left[i];
        assign out_any[i] = in[i] || in_shift_right[i];
        assign out_different[i] = in[i] != ((i == 99) ? in[0] : in_shift_left[i]);
    end
endgenerate

endmodule