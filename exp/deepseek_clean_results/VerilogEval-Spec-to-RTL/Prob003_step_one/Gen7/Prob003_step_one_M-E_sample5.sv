module TopModule (
    output reg one
);
    // Define states (though we only need one)
    localparam STATE_ON = 1'b1;
    
    // Clock and reset would normally be inputs, but we'll create internal ones
    reg clk = 0;
    reg rst_n = 0;
    
    // Simple clock generator for simulation
    always #5 clk = ~clk;
    
    // Reset generator for simulation
    initial begin
        #10 rst_n = 1;
    end
    
    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            one <= 1'b0;  // Reset to 0 (though we could reset to 1)
        end else begin
            one <= STATE_ON;  // Always drive high after reset
        end
    end
endmodule