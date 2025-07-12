module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire [1:0] sel_ab, sel_cd;
    
    // Priority encoder for a/b (b has higher priority)
    assign sel_ab = b ? 2'b10 : (a ? 2'b01 : 2'b00);
    
    // Priority encoder for c/d (d has higher priority)
    assign sel_cd = d ? 2'b10 : (c ? 2'b01 : 2'b00);
    
    // Output selection
    assign q = (sel_ab[1] | sel_ab[0]) & (sel_cd[1] | sel_cd[0]);

endmodule