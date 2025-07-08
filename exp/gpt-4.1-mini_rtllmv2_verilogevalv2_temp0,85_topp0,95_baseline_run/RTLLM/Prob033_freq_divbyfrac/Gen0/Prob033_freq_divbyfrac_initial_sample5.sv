module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for fractional division by 3.5:
    // 3.5 = 7 / 2, so the counter counts up to 7 cycles (MUL2_DIV_CLK)
    localparam MUL2_DIV_CLK = 7;

    // Counter to track clk cycles within the period
    reg [2:0] cnt; // enough to count to 7
    // Toggle signals for rising and falling edge clocks
    reg clk_div_rise;
    reg clk_div_fall;

    // State to track which half-cycle (4 or 3) we're in
    // We alternate between 4 and 3 input clock cycles for the high and low periods
    reg toggle_period; // 0: high period 4 clocks, low period 3 clocks; 1: high period 3 clocks, low period 4 clocks

    // Counter increments every clk edge (rising edge)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            toggle_period <= 0;
            clk_div_rise <= 0;
        end else begin
            // Counter counts from 0 to 6 (7 counts total)
            if (cnt == MUL2_DIV_CLK - 1) begin
                cnt <= 0;
                toggle_period <= ~toggle_period; // alternate period length pattern every full cycle
                clk_div_rise <= ~clk_div_rise;   // toggle the rising edge clock output at the end of full cycle
            end else begin
                cnt <= cnt + 1;
                // clk_div_rise is stable between toggles
            end
        end
    end

    // Generate falling-edge based clock division with appropriate phase shift
    // We generate clk_div_fall by counting on falling edge of clk with half cycle delay
    reg [2:0] cnt_fall;
    reg toggle_period_fall;
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_fall <= 0;
            toggle_period_fall <= 0;
            clk_div_fall <= 0;
        end else begin
            if (cnt_fall == MUL2_DIV_CLK - 1) begin
                cnt_fall <= 0;
                toggle_period_fall <= ~toggle_period_fall;
                clk_div_fall <= ~clk_div_fall;
            end else begin
                cnt_fall <= cnt_fall + 1;
            end
        end
    end

    // Final divided clock: OR of both edges clocks to achieve fractional division with better duty cycle
    assign clk_div = clk_div_rise | clk_div_fall;

endmodule