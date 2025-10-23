module TopModule (
    output out
);
    reg out_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_reg <= 1'b0;
        end
    end
    
    assign out = out_reg;
    
    // Internal signals (not in interface)
    wire clk;    // Would be connected to a clock source in real implementation
    wire reset;  // Would be connected to a reset source in real implementation
    
    // Initialize the signals (for simulation)
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
    end
    
    // Generate clock
    always #5 clk = ~clk;
endmodule