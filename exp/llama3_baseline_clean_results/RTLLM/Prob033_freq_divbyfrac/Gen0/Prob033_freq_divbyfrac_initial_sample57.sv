module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the constant for fractional frequency division
localparam MUL2_DIV_CLK = 7;

// Internal signals for divided clocks with uneven periods
reg clk_div1;
reg clk_div2;
reg clk_div1_dly; // Delayed version of clk_div1
reg clk_div2_adv; // Advanced version of clk_div2

// Counter to track clock cycles
reg [2:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        clk_div1_dly <= 1'b0;
        clk_div2_adv <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        // Increment counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate divided clocks with uneven periods
        if (cnt == 3'b100) begin // Start of 4-cycle period
            clk_div1 <= 1'b1;
        end else if (cnt == 3'b011) begin // End of 4-cycle period
            clk_div1 <= 1'b0;
        end

        if (cnt == 3'b011) begin // Start of 3-cycle period
            clk_div2 <= 1'b1;
        end else if (cnt == 3'b101) begin // End of 3-cycle period
            clk_div2 <= 1'b0;
        end

        // Phase-shift divided clocks
        if (clk_div1) begin
            clk_div1_dly <= 1'b1;
        end else if (cnt == 3'b001) begin // Delay by half a clock period
            clk_div1_dly <= 1'b0;
        end

        if (clk_div2) begin
            clk_div2_adv <= 1'b1;
        end else if (cnt == 3'b010) begin // Advance by half a clock period
            clk_div2_adv <= 1'b0;
        end

        // Combine phase-shifted clocks to produce final output
        clk_div <= clk_div1_dly | clk_div2_adv;
    end
end

endmodule