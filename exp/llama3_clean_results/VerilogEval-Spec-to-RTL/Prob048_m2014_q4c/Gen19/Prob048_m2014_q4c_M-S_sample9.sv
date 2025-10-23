module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

always @(posedge clk)
    q <= r? 1'b0 : d;

endmodule