module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shifted versions of input
    wire [3:0] left_shifted  = {in[2:0], 1'b0};  // Shift left (LSB filled with 0)
    wire [3:0] right_shifted = {1'b0, in[3:1]};  // Shift right (MSB filled with 0)
    wire [3:0] circ_shifted  = {in[0], in[3:1]}; // Circular right shift

    // out_both: AND with left neighbor (using right-shifted version)
    assign out_both = {1'b0, in[2:0] & right_shifted[2:0]};

    // out_any: OR with right neighbor (using left-shifted version)
    assign out_any = {in[3:1] | left_shifted[3:1], 1'b0};

    // out_different: XOR with circularly shifted version
    assign out_different = in ^ circ_shifted;

endmodule