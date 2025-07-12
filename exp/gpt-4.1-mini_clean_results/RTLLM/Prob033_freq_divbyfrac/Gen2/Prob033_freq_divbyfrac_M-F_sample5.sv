module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Division factors for 3.5x fractional division:
    // Alternate toggle periods: 4 cycles, then 3 cycles -> average 3.5
    localparam integer PERIOD_A = 3;
    localparam integer PERIOD_B = 4;

    // Counters for posedge and negedge domains
    reg [2:0] count_pos;
    reg [2:0] count_neg;

    // Toggle period selectors for posedge and negedge domains
    reg period_sel_pos; // 0 => PERIOD_A=3, 1 => PERIOD_B=4
    reg period_sel_neg;

    // Intermediate divided clocks updated on posedge and negedge respectively
    reg clk_div_pos;
    reg clk_div_neg;

    // Generate clk_div_pos - triggered on rising edge of clk
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_pos      <= 3'd0;
            period_sel_pos <= 1'b1; // Start with PERIOD_B=4 for first interval
            clk_div_pos    <= 1'b0;
        end else begin
            if (count_pos == ((period_sel_pos) ? PERIOD_B - 1 : PERIOD_A - 1)) begin
                clk_div_pos    <= ~clk_div_pos;          // Toggle clk_div_pos output
                count_pos      <= 3'd0;                   // Reset counter
                period_sel_pos <= ~period_sel_pos;       // Switch period for next cycle
            end else begin
                count_pos <= count_pos + 1'b1;
            end
        end
    end

    // Generate clk_div_neg - triggered on falling edge of clk (delayed by half clk period)
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count_neg      <= 3'd0;
            period_sel_neg <= 1'b0; // Start with PERIOD_A=3 to alternate out of phase with posedge
            clk_div_neg    <= 1'b0;
        end else begin
            if (count_neg == ((period_sel_neg) ? PERIOD_B - 1 : PERIOD_A - 1)) begin
                clk_div_neg    <= ~clk_div_neg;          // Toggle clk_div_neg output
                count_neg      <= 3'd0;                   // Reset counter
                period_sel_neg <= ~period_sel_neg;       // Switch period for next cycle
            end else begin
                count_neg <= count_neg + 1'b1;
            end
        end
    end

    // Final output clock is the logical OR of the two phase-shifted intermediate clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule