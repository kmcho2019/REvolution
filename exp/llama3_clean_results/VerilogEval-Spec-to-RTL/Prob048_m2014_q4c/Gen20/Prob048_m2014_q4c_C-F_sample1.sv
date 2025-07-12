module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;
end

endmodule