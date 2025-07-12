module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both[3] is don't-care (left neighbor doesn't exist)
    assign out_both = {1'bx, in[2:0] & in[3:1]};
    
    // out_any[0] is don't-care (right neighbor doesn't exist)
    assign out_any = {in[3:1] | in[2:0], 1'bx};
    
    // out_different uses wrap-around comparison via XOR
    assign out_different = in ^ {in[0], in[3:1]};

endmodule