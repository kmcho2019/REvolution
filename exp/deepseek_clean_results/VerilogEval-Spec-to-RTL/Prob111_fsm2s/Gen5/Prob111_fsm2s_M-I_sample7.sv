module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

    localparam OFF = 1'b0;
    localparam ON  = 1'b1;
    
    wire state_change;
    reg clock_enable;
    
    // Detect when state will change
    assign state_change = (out == OFF) ? j : k;
    
    // Clock gating control
    always @* begin
        clock_enable = reset | state_change;
    end
    
    // State transition with clock gating
    always @(posedge clk) begin
        if (reset) begin
            out <= OFF;
        end else if (clock_enable) begin
            out <= (out == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
        end
    end

endmodule