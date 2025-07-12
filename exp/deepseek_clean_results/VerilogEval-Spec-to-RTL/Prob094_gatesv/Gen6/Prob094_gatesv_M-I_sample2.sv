module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = {1'b0, in[3:1] & in[2:0]};  // Explicitly set MSB to 0
    assign out_any = {in[3:1] | in[2:0], 1'b0};    // Explicitly set LSB to 0
    assign out_different = in ^ {in[0], in[3:1]};  // Maintain efficient XOR

endmodule