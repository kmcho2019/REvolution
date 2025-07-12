module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for PLLs
reg clk_pll_4;  // PLL output with 4-clock cycle period
reg clk_pll_3;  // PLL output with 3-clock cycle period

// Signals for phase-shifting
reg clk_pll_4_dly;  // Delayed version of clk_pll_4
reg clk_pll_3_adv;  // Advanced version of clk_pll_3

// Clock cycle counter
reg [2:0] counter;
reg [2:0] next_counter;

// Control signals for PLLs
reg pll_4_en;  // Enable signal for PLL with 4-clock cycle period
reg pll_3_en;  // Enable signal for PLL with 3-clock cycle period

// Digital signal processing unit
reg dsp_out;  // Output of DSP unit

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all signals
        counter <= 3'd0;
        clk_pll_4 <= 1'b0;
        clk_pll_3 <= 1'b0;
        clk_pll_4_dly <= 1'b0;
        clk_pll_3_adv <= 1'b0;
        pll_4_en <= 1'b0;
        pll_3_en <= 1'b0;
        dsp_out <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        case (counter)
            3'd0: begin
                // Enable PLL with 4-clock cycle period
                pll_4_en <= 1'b1;
                next_counter <= 3'd1;
            end
            3'd1, 3'd2, 3'd3: begin
                next_counter <= counter + 1;
            end
            3'd4: begin
                // Disable PLL with 4-clock cycle period
                pll_4_en <= 1'b0;
                // Enable PLL with 3-clock cycle period
                pll_3_en <= 1'b1;
                next_counter <= 3'd5;
            end
            3'd5: begin
                // Disable PLL with 3-clock cycle period
                pll_3_en <= 1'b0;
                next_counter <= 3'd0;
            end
        endcase
        counter <= next_counter;

        // Phase-shifting logic
        if (counter == 3'd0) begin
            clk_pll_4_dly <= clk_pll_4;
        end else if (counter == 3'd4) begin
            clk_pll_4_dly <= 1'b0;
        end

        if (counter == 3'd2) begin
            clk_pll_3_adv <= clk_pll_3;
        end else if (counter == 3'd5) begin
            clk_pll_3_adv <= 1'b0;
        end

        // Digital signal processing unit
        dsp_out <= (clk_pll_4_dly | clk_pll_3_adv);

        // Assign output
        clk_div <= dsp_out;
    end
end

// PLL with 4-clock cycle period
always @(posedge clk) begin
    if (pll_4_en) begin
        clk_pll_4 <= ~clk_pll_4;
    end
end

// PLL with 3-clock cycle period
always @(posedge clk) begin
    if (pll_3_en) begin
        clk_pll_3 <= ~clk_pll_3;
    end
end

endmodule