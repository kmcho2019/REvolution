module TopModule (
    output reg zero
);
    // Clock and reset signals (not used in this module)
    wire clk = 1'b0;  // Clock tied low since we don't need it
    wire rst_n = 1'b1; // Reset inactive
    
    // Clock gating control
    wire enable = 1'b0; // Never enable the flip-flop
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            zero <= 1'b0;  // Reset value
        end
        else if (enable) begin
            zero <= 1'b0;  // Normal operation (never reached)
        end
    end
    
    // Continuous assignment alternative if synthesis optimizes away the flop
    initial zero = 1'b0;
endmodule