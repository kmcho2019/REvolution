module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create circularly shifted versions of input
    wire [3:0] left_shifted = {in[2:0], in[3]};  // Circular left shift
    wire [3:0] right_shifted = {in[0], in[3:1]}; // Circular right shift

    // out_both: AND with left neighbor (using right_shifted)
    assign out_both = in & right_shifted;
    assign out_both[3] = 1'b0;  // MSB not needed per spec

    // out_any: OR with right neighbor (using left_shifted)
    assign out_any = in | left_shifted;
    assign out_any[0] = 1'b0;   // LSB not needed per spec

    // out_different: XOR with left neighbor (using right_shifted)
    assign out_different = in ^ right_shifted;

endmodule