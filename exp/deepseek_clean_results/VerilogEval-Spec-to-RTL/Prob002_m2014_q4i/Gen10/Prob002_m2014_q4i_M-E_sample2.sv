module TopModule(output out);
    // Internal clock (not used but shows clock-gating concept)
    wire clk;
    
    // Clock gating control (hard-wired to enable)
    wire clk_enable = 1'b1;
    
    // Gated clock signal
    wire gated_clk;
    
    // Clock gating cell (would be a library cell in real designs)
    assign gated_clk = clk & clk_enable;
    
    // Constant generator flip-flop
    reg constant_reg;
    
    always @(posedge gated_clk) begin
        constant_reg <= 1'b0;  // Always generate 0
    end
    
    // Output assignment
    assign out = constant_reg;
    
    // Dummy clock driver (would be removed in real design)
    assign clk = 1'b0;  // Static value since we don't need actual clocking
endmodule