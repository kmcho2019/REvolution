module TopModule(input clk, input d, output q);
    wire clk_delayed;
    wire edge_detect;
    reg q_reg;
    
    // Create delayed clock (simulating propagation delay)
    assign #1 clk_delayed = clk;
    
    // Positive edge detection
    assign edge_detect = clk & ~clk_delayed;
    
    // Data sampling on edge detection
    assign q = edge_detect ? d : q_reg;
    
    // Feedback to hold value between edges
    always @(*) begin
        q_reg = q;
    end
endmodule