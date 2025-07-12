module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shifted versions of the input vector
    wire [3:0] in_shifted_left;
    wire [3:0] in_shifted_right;
    
    // Shift input vector to the right and left
    assign in_shifted_right = {1'b0, in[3:1]}; // For out_any and out_both
    assign in_shifted_left = {in[2:0], in[3]}; // For out_different

    // out_both
    assign out_both = in & in_shifted_right;
    assign out_both[3] = 1'b0; // No left neighbor for in[3]

    // out_any
    assign out_any = in | in_shifted_right;
    assign out_any[0] = in[0]; // No right neighbor for in[0]

    // out_different
    assign out_different = in ^ in_shifted_left;

endmodule