module right_shifter(
    input clk,  
    input d,    
    output reg [7:0] q  
);

    initial q = 0;  
    always @(posedge clk) 
        q <= {d, q[7:1]};  

endmodule