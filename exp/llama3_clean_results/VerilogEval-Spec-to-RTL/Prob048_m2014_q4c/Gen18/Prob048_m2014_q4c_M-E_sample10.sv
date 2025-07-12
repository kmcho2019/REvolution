module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

logic q_reg;

always @(posedge clk) begin
    if (r) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= d;
    end
end

assign q = q_reg;

endmodule