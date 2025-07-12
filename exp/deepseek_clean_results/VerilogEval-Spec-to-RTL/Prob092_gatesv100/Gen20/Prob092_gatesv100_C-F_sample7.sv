module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    ///////////////////////////////////////////////////////////////////////////
    // out_both: For each bit, indicate if current bit AND left neighbor are 1
    //           Bit 99 has no left neighbor, so set to 0
    ///////////////////////////////////////////////////////////////////////////
    assign out_both = {1'b0, in[99:1] & in[98:0]};

    ///////////////////////////////////////////////////////////////////////////
    // out_any: For each bit, indicate if current bit OR right neighbor is 1
    //          Bit 0 has no right neighbor, so set to 0
    ///////////////////////////////////////////////////////////////////////////
    assign out_any = {in[98:0] | in[99:1], 1'b0};

    ///////////////////////////////////////////////////////////////////////////
    // out_different: For each bit, indicate if current bit differs from left
    //                neighbor (with wrap-around: bit 99 compares with bit 0)
    ///////////////////////////////////////////////////////////////////////////
    assign out_different = in ^ {in[0], in[99:1]};

endmodule