module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define constants
parameter MUL2_DIV_CLK = 7; // total clock cycles
parameter DIV_CLK_CYCLE1 = 4; // first divided clock cycle
parameter DIV_CLK_CYCLE2 = 3; // second divided clock cycle

// Internal signals
reg [2:0] counter; // 3-bit counter
reg clk_div_int1; // first intermediate divided clock
reg clk_div_int2; // second intermediate divided clock
reg clk_div_phase1; // first phase-shifted divided clock
reg clk_div_phase2; // second phase-shifted divided clock

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000;
        clk_div_int1 <= 1'b0;
        clk_div_int2 <= 1'b0;
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
        clk_div <= 1'b0;
    end else begin
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'b000;
        end else begin
            counter <= counter + 1;
        end

        // Generate intermediate divided clocks
        if (counter < DIV_CLK_CYCLE1) begin
            clk_div_int1 <= 1'b1;
        end else begin
            clk_div_int1 <= 1'b0;
        end

        if ((counter >= DIV_CLK_CYCLE1) && (counter < MUL2_DIV_CLK)) begin
            clk_div_int2 <= 1'b1;
        end else begin
            clk_div_int2 <= 1'b0;
        end

        // Phase-shift divided clocks
        if (counter == 0) begin
            clk_div_phase1 <= 1'b1;
        end else if (counter == 1) begin
            clk_div_phase1 <= 1'b0;
        end

        if (counter == DIV_CLK_CYCLE1 - 1) begin
            clk_div_phase2 <= 1'b1;
        end else if (counter == DIV_CLK_CYCLE1) begin
            clk_div_phase2 <= 1'b0;
        end

        // Generate final fractional divided clock
        clk_div <= (clk_div_int1 | clk_div_int2) | (clk_div_phase1 | clk_div_phase2);
    end
end

endmodule