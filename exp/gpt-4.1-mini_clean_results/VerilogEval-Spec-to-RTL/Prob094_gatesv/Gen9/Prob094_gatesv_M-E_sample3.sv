module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift 'in' left by one, adding 0 at LSB, so out_both[i] = in[i] & in[i+1]
    // out_both[3] has no left neighbor, so set it to 0 explicitly
    wire [3:0] in_left_shifted = {in[2:0], 1'b0};
    assign out_both = in & in_left_shifted;

    // Shift 'in' right by one, adding 0 at MSB, so out_any[i] = in[i] | in[i-1]
    // out_any[0] has no right neighbor, so set it to 0 explicitly
    wire [3:0] in_right_shifted = {1'b0, in[3:1]};
    assign out_any = in | in_right_shifted;

    // For out_different, neighbor to left wraps around: neighbor of in[3] is in[0]
    // Create wrapped left shift by concatenating in[0] at MSB followed by in[3:1]
    wire [3:0] in_wrapped_left = {in[0], in[3:1]};
    assign out_different = in ^ in_wrapped_left;

endmodule