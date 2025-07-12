module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_delayed;
    reg last_clk;
    wire edge_detect;

    // Create a delayed version of the clock (simulated with a buffer chain)
    // In real implementation, this would use precise delay elements
    assign clk_delayed = ~(~clk);  // Simple delay simulation
    
    // Detect both edges by comparing current and delayed clock
    assign edge_detect = (clk ^ clk_delayed);

    always @(posedge edge_detect) begin
        q <= d;
    end

endmodule