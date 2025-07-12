module freq_divbyfrac(
    input  clk,       // Input clock signal
    input  rst_n,     // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Parameters for the frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_HALF_PERIOD = 4; // Clock cycles for half period
parameter DIV_CLK_FULL_PERIOD = 7; // Clock cycles for full period

// Internal signals
reg [2:0] cnt; // Counter to cycle through clock periods
reg div_clk_int; // Intermediate divided clock signal
reg div_clk_int_dly; // Delayed intermediate divided clock signal
reg div_clk_int_adv; // Advanced intermediate divided clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        div_clk_int <= 1'b0;
        div_clk_int_dly <= 1'b0;
        div_clk_int_adv <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            div_clk_int <= 1'b0;
            div_clk_int_dly <= 1'b0;
            div_clk_int_adv <= 1'b0;
        end else begin
            cnt <= cnt + 1'b1;
            // Generate intermediate divided clock signals
            if (cnt == DIV_CLK_HALF_PERIOD) begin
                div_clk_int <= 1'b1;
            end else if (cnt == DIV_CLK_FULL_PERIOD - 1) begin
                div_clk_int <= 1'b0;
            end
            // Phase-shift intermediate clock signals
            if (cnt == 1) begin
                div_clk_int_dly <= div_clk_int;
                div_clk_int_adv <= div_clk_int;
            end else begin
                div_clk_int_dly <= div_clk_int_dly;
                div_clk_int_adv <= div_clk_int_adv;
            end
        end
    end
end

// Final divided clock output logic
always @(*) begin
    if (div_clk_int_dly || div_clk_int_adv) begin
        clk_div = 1'b1;
    end else begin
        clk_div = 1'b0;
    end
end

endmodule