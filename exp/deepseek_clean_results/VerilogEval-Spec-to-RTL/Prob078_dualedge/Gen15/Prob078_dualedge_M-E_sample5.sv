module TopModule (
    input clk,
    input d,
    output reg q
);

    // Internal signals
    wire clk_delayed;
    wire sample_enable;
    reg delayed_clk;

    // Create delayed version of clock (approximately 1/4 period delay)
    // Note: In real implementation, this would use a calibrated delay element
    always @(posedge clk) begin
        delayed_clk <= ~delayed_clk;
    end

    // Clock phase detection
    assign sample_enable = clk ^ delayed_clk;

    // Main sampling flip-flop
    always @(posedge sample_enable) begin
        q <= d;
    end

endmodule