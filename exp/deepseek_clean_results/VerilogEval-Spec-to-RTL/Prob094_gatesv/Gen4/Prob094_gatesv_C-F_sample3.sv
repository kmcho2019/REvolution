module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    assign out_both = {1'b0, in[3:1] & in[2:0]};  // out_both[3] explicitly 0
    assign out_any = {in[3:1] | in[2:0], 1'b0};   // out_any[0] explicitly 0
    assign out_different = in ^ {in[0], in[3:1]};  // Efficient wrap-around XOR

endmodule