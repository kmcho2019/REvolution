module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

always @(posedge clk)
    if (r) 
        q <= 1'b0;
    else 
        q <= d;

endmodule