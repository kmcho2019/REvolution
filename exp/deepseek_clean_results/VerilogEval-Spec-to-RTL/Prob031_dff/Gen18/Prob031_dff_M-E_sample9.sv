module TopModule(input clk, input d, output q);
    // Create a delayed version of the clock
    wire clk_delayed;
    assign #1 clk_delayed = clk;  // Unit delay for simulation
    
    // Edge detection: current clk is 1 and delayed is 0
    wire pos_edge;
    assign pos_edge = clk & ~clk_delayed;
    
    // The flip-flop behavior
    reg q_reg;
    assign q = q_reg;
    
    always @(*) begin
        if (pos_edge) begin
            q_reg = d;
        end
    end
endmodule