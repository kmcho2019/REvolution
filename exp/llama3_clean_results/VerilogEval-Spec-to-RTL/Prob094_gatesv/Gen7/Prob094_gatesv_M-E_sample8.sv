module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] in_shifted_left;
    wire [3:0] in_shifted_right;

    assign in_shifted_left = {in[2:0], in[3]}; // circular shift to the right
    assign in_shifted_right = {in[0], in[3:1]}; // shift to the left

    assign out_both = in & in_shifted_left;
    assign out_any = in | in_shifted_right;
    assign out_different = in ^ in_shifted_left;

    // since out_both[3] and out_any[0] are not needed, we can set them to 0
    assign out_both[3] = 1'b0;
    assign out_any[0] = in[0]; // this is correct because there's no bit to the right of in[0]

endmodule