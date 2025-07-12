module freq_divbyfrac(
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for 3.5x frequency division (counting 7 cycles)
localparam MUL2_DIV_CLK = 7;

// Counter to track clock cycles for fractional division
reg [2:0] cycle_cnt;

// Intermediate clock signals for phase-shifting
reg clk_div_int_1;
reg clk_div_int_2;

// Phase-shifted clock signals
reg clk_div_int_1_ph;
reg clk_div_int_2_ph;

// Duty cycle imbalance adjustment
reg [1:0] duty_cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset counters and intermediate clocks
        cycle_cnt <= 3'b000;
        clk_div_int_1 <= 1'b0;
        clk_div_int_2 <= 1'b0;
        clk_div_int_1_ph <= 1'b0;
        clk_div_int_2_ph <= 1'b0;
        duty_cnt <= 2'b00;
        clk_div <= 1'b0;
    end else begin
        // Increment cycle counter
        if (cycle_cnt == MUL2_DIV_CLK - 1) begin
            cycle_cnt <= 3'b000;
        end else begin
            cycle_cnt <= cycle_cnt + 1'b1;
        end

        // Generate intermediate clocks based on cycle counter
        if (cycle_cnt < 4) begin
            clk_div_int_1 <= 1'b1;
        end else if (cycle_cnt == 4) begin
            clk_div_int_1 <= 1'b0;
        end

        if (cycle_cnt >= 4 && cycle_cnt < 7) begin
            clk_div_int_2 <= 1'b1;
        end else if (cycle_cnt == 7 - 1) begin
            clk_div_int_2 <= 1'b0;
        end

        // Phase-shift intermediate clocks
        if (clk_div_int_1) begin
            clk_div_int_1_ph <= ~clk_div_int_1;
        end else begin
            clk_div_int_1_ph <= clk_div_int_1;
        end

        if (clk_div_int_2) begin
            clk_div_int_2_ph <= ~clk_div_int_2;
        end else begin
            clk_div_int_2_ph <= clk_div_int_2;
        end

        // Logically OR phase-shifted clocks for final output
        clk_div <= clk_div_int_1_ph | clk_div_int_2_ph;

        // Adjust duty cycle imbalance
        if (duty_cnt == 2'b11) begin
            duty_cnt <= 2'b00;
        end else begin
            duty_cnt <= duty_cnt + 1'b1;
        end
    end
end

endmodule