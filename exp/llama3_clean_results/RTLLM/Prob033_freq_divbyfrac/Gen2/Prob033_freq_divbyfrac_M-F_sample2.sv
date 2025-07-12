module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] phase_cnt;  // Counter to track phase
reg clk_div_int1;  // Intermediate divided clock (4 cycles)
reg clk_div_int2;  // Intermediate divided clock (3 cycles)
reg clk_div_int1_delayed;  // Delayed intermediate divided clock
reg clk_div_int2_advanced;  // Advanced intermediate divided clock

// Counter logic and clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset counter
        phase_cnt <= 2'b00;  // Reset phase counter
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_int1_delayed <= 1'b0;
        clk_div_int2_advanced <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        cnt <= cnt + 1'b1;  // Increment counter
        phase_cnt <= phase_cnt + 1'b1;  // Increment phase counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;  // Reset counter
            phase_cnt <= 2'b00;  // Reset phase counter
        end

        // Generate intermediate divided clocks
        if (cnt >= 3'b100 && cnt <= 3'b111) begin
            clk_div_int1 <= 1'b1;  // 4 cycles clock
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if (cnt >= 3'b000 && cnt <= 3'b010) begin
            clk_div_int2 <= 1'b1;  // 3 cycles clock
        end else begin
            clk_div_int2 <= 1'b0;
        end

        // Phase-shifting mechanism
        if (phase_cnt == 2'b01) begin
            clk_div_int1_delayed <= clk_div_int1;  // Delay intermediate clock
        end else begin
            clk_div_int1_delayed <= 1'b0;
        end

        if (phase_cnt == 2'b11) begin
            clk_div_int2_advanced <= clk_div_int2;  // Advance intermediate clock
        end else begin
            clk_div_int2_advanced <= 1'b0;
        end

        // Generate final fractional divided clock output
        clk_div <= clk_div_int1_delayed | clk_div_int2_advanced;
    end
end

endmodule