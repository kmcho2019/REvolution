module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create shifted versions of input
    wire [3:0] left_shifted = {in[0], in[3:1]};  // circular left shift
    wire [3:0] right_shifted = {in[2:0], in[3]}; // circular right shift

    // out_both: current AND left neighbor (mask MSB)
    assign out_both = (in & left_shifted) & 4'b0111;

    // out_any: current OR right neighbor (mask LSB)
    assign out_any = (in | right_shifted) & 4'b1110;

    // out_different: current XOR left neighbor (wrap-around)
    assign out_different = in ^ left_shifted;

endmodule