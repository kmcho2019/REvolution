module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg terminal_count;
reg clk_enable;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
        terminal_count <= 1'b0;
        clk_enable <= 1'b1;
    end
    else if (clk_enable) begin
        terminal_count <= q[3] & q[0];  // Registered terminal count detection
        
        if (terminal_count) begin
            q <= 4'b0000;
            clk_enable <= 1'b1;  // Re-enable after reset
        end
        else begin
            q <= q + 1'b1;
            // Disable clock for next cycle if we're at 8 (1000)
            clk_enable <= ~(q == 4'b1000);
        end
    end
    else begin
        // Clock gated - maintain state
        clk_enable <= 1'b1;  // Re-enable after one cycle
    end
end

endmodule