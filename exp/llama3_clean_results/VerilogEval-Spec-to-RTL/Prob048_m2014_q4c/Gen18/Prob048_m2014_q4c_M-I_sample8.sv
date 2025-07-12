module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Active high reset
    end else begin
        q <= d; // D flip-flop behavior
    end
end

endmodule