module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] left_shifted = {in[2:0], 1'b0};  // Left shift for out_both
    wire [3:0] right_shifted = {1'b0, in[3:1]}; // Right shift for out_any
    wire [3:0] circular_shifted = {in[2:0], in[3]}; // Circular shift for out_different

    // out_both: AND with left-shifted version (ignore MSB)
    assign out_both = in & left_shifted;
    assign out_both[3] = 1'b0;  // Explicitly set unused bit

    // out_any: OR with right-shifted version (ignore LSB)
    assign out_any = in | right_shifted;
    assign out_any[0] = 1'b0;   // Explicitly set unused bit

    // out_different: XOR with circular-shifted version
    assign out_different = in ^ circular_shifted;

endmodule