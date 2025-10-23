module TopModule (
    input [3:0] in,
    output [1:0] pos
);

    // Decision tree implementation
    wire [1:0] level0, level1, level2;
    
    // Lowest priority level (bit 0)
    assign level0 = (in[0]) ? 2'b00 : 2'b00; // Default to 0 if no bits are set
    
    // Next priority level (bit 1)
    assign level1 = (in[1]) ? 2'b01 : level0;
    
    // Next priority level (bit 2)
    assign level2 = (in[2]) ? 2'b10 : level1;
    
    // Highest priority level (bit 3)
    assign pos = (in[3]) ? 2'b11 : level2;

endmodule