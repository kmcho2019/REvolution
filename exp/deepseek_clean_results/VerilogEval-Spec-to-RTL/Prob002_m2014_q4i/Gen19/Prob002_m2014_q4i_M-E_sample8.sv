module TopModule (
    output reg out
);
    // Internal clock signal (permanently disabled)
    wire clk = 1'b0;
    
    // Internal reset signal (used only for initialization)
    wire rst = 1'b1;
    
    // Clock-gated flip-flop implementation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 1'b0;  // Initialize to 0 on reset
        end
        // No else case - clock is permanently disabled
    end
endmodule