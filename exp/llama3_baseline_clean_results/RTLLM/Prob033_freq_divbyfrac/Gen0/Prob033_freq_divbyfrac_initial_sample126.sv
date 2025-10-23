module freq_divbyfrac (
    input  clk,    // Input clock signal
    input  rst_n,  // Active low reset signal
    output clk_div // Fractionally divided clock output
);

// Parameters for fractional division (3.5x)
parameter MUL2_DIV_CLK = 7; // Total clock cycles for division
parameter DIV_CLK_P1 = 4;   // Clock cycles for first phase
parameter DIV_CLK_P2 = 3;   // Clock cycles for second phase

// Internal signals
reg [2:0] cnt; // Counter to track clock cycles
reg clk_div_p1; // First intermediate clock signal
reg clk_div_p2; // Second intermediate clock signal (phase-shifted)
reg clk_div_p1_dly; // Delayed version of first intermediate clock
reg clk_div_p2_adv; // Advanced version of second intermediate clock

// Counter to track clock cycles
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
    end else if (cnt == MUL2_DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Generate intermediate clock signals based on counter value
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p1 <= 1'b0;
        clk_div_p2 <= 1'b0;
    end else if (cnt < DIV_CLK_P1) begin
        clk_div_p1 <= 1'b1;
        clk_div_p2 <= 1'b0;
    end else begin
        clk_div_p1 <= 1'b0;
        clk_div_p2 <= 1'b1;
    end
end

// Phase-shifting and delaying clock signals
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_div_p1_dly <= 1'b0;
        clk_div_p2_adv <= 1'b0;
    end else begin
        // Delay first intermediate clock by half a clock period
        clk_div_p1_dly <= clk_div_p1;
        // Advance second intermediate clock by half a clock period
        if (cnt == DIV_CLK_P2 - 1) begin
            clk_div_p2_adv <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_p2_adv <= 1'b0;
        end
    end
end

// Combine phase-shifted clock signals to produce final output
assign clk_div = clk_div_p1_dly | clk_div_p2_adv;

endmodule