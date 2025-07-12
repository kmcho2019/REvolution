module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

logic next_q;

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule