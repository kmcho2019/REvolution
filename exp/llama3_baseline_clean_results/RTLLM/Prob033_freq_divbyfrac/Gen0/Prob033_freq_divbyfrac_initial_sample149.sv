module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter LONG_CLK_CYCLE = 4; // Clock cycles for longer period
parameter SHORT_CLK_CYCLE = 3; // Clock cycles for shorter period

// Internal signals
reg [2:0] counter; // Counter to track clock cycles
reg long_clk; // Signal for longer clock period
reg short_clk; // Signal for shorter clock period
reg delayed_clk; // Phase-delayed clock signal
reg advanced_clk; // Phase-advanced clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 0;
        long_clk <= 0;
        short_clk <= 0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end

        // Generate uneven clock periods
        if (counter < LONG_CLK_CYCLE) begin
            long_clk <= 1;
        end else begin
            long_clk <= 0;
        end

        if (counter >= LONG_CLK_CYCLE && counter < MUL2_DIV_CLK) begin
            short_clk <= 1;
        end else begin
            short_clk <= 0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        delayed_clk <= 0;
        advanced_clk <= 0;
    end else begin
        // Delay long_clk by half a clock period
        if (long_clk && ~clk) begin
            delayed_clk <= 1;
        end else if (~long_clk || clk) begin
            delayed_clk <= 0;
        end

        // Advance short_clk by half a clock period
        if (short_clk && clk) begin
            advanced_clk <= 1;
        end else if (~short_clk || ~clk) begin
            advanced_clk <= 0;
        end
    end
end

// Final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div <= 0;
    end else begin
        // Logically OR the two intermediate clocks
        clk_div <= delayed_clk || advanced_clk;
    end
end

endmodule