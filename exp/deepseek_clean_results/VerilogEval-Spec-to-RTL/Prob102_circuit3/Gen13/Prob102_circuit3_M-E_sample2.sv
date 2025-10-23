module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Priority selection: b has higher priority than a
    wire enable = b ? 1'b1 : (a ? 1'b1 : 1'b0);
    
    // Priority selection for data: d has higher priority than c
    wire data = d ? 1'b1 : (c ? 1'b1 : 1'b0);
    
    // Final output is data only when enabled
    assign q = enable & data;

endmodule