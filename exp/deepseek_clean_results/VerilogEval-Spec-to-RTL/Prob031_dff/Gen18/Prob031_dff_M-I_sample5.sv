module TopModule(input clk, input d, output reg q);
    // For practical designs, you might want to add an asynchronous reset:
    // always @(posedge clk or posedge reset) 
    //     if (reset) q <= 1'b0;
    //     else q <= d;
    
    // Current minimal implementation:
    always @(posedge clk) q <= d;
endmodule