module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Direct assignments with reduced width where possible
    assign out_both = {1'bx, in[2:0] & in[3:1]};  // Only 3 meaningful bits
    assign out_any = {in[3:1] | in[2:0], 1'bx};   // Only 3 meaningful bits
    assign out_different = in ^ {in[0], in[3:1]};  // Efficient wrap-around XOR

endmodule