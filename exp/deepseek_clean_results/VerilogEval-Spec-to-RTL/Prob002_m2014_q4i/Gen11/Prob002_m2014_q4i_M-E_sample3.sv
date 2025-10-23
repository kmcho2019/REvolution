module TopModule (
    output out
);
    // 2-input LUT implementation
    // Truth table: 00->0, 01->0, 10->0, 11->0
    wire dummy1, dummy2;
    
    // Inputs can be tied to anything - output doesn't depend on them
    assign dummy1 = 1'b0;
    assign dummy2 = 1'b1;
    
    // LUT implementation
    assign out = (dummy1 & dummy2) ? 1'b0 :  // 11 case
                (dummy1 & ~dummy2) ? 1'b0 : // 10 case
                (~dummy1 & dummy2) ? 1'b0 :  // 01 case
                1'b0;                        // 00 case
endmodule