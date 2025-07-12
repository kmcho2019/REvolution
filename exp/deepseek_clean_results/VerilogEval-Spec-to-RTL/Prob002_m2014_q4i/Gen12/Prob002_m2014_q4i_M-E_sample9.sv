module TopModule (
    output out
);
    // Internal clock generator
    reg clk = 0;
    always #5 clk = ~clk;
    
    // Synchronous logic
    reg out_reg;
    always @(posedge clk) begin
        out_reg <= 1'b0;
    end
    
    assign out = out_reg;
    
    // Initial block for simulation
    initial begin
        out_reg = 1'b0;
    end
endmodule