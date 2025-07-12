`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10  // Clock period in ns
) (
    output reg clk = 0,
    input reset = 0
);

    // Calculate counter maximum value (period in ns * 10 for 100ps precision)
    localparam COUNTER_MAX = PERIOD * 10;
    localparam HALF_PERIOD = COUNTER_MAX / 2;
    
    reg [31:0] counter = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk <= 0;
        end else begin
            // Increment counter with 100ps precision
            counter <= counter + 1;
            
            // Toggle clock at half period
            if (counter >= HALF_PERIOD - 1) begin
                clk <= ~clk;
                counter <= 0;
            end
        end
    end

    // Generate internal high-speed clock (10GHz) for precise timing
    reg fast_clk = 0;
    always #0.05 fast_clk = ~fast_clk;  // 100ps period (10GHz)

    // Synchronize main clock to fast clock domain
    always @(posedge fast_clk) begin
        if (reset) begin
            clk <= 0;
            counter <= 0;
        end
    end

    // Parameter validation
    initial begin
        if (PERIOD <= 0) $fatal("PERIOD must be positive");
    end

endmodule