module TopModule(
    input  logic clk,  
    input  logic d,    
    input  logic r,    
    output logic q      
);

logic mux_out;

always @(posedge clk) begin
    q <= mux_out;
end

always @(*) begin
    mux_out = r ? 1'b0 : d;
end

endmodule