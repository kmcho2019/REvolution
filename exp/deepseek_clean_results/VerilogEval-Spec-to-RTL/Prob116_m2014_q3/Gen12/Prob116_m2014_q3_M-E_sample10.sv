module TopModule(
    input [3:0] x,  // x[3]x[4]x[1]x[2] ordering
    output f
);
    // First level mux selects based on x[3:4] (MSBs)
    wire [1:0] sub_func;
    
    // Sub-function for x[3:4] = 00 (don't-cares optimized to 0)
    assign sub_func[0] = 1'b0;
    
    // Sub-function for x[3:4] = 01
    wire [1:0] func_01;
    assign func_01[0] = ~x[1] & ~x[2];  // 00 case
    assign func_01[1] = x[1] & x[2];    // 11 case
    assign sub_func[1] = func_01[x[1:2]];
    
    // Sub-function for x[3:4] = 11 (optimized don't-cares)
    assign sub_func[2] = x[1] | ~x[2];
    
    // Sub-function for x[3:4] = 10 (optimized don't-cares)
    assign sub_func[3] = ~x[2];
    
    // Final output selection
    assign f = sub_func[x[3:4]];
endmodule