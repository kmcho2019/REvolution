module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameters for division by 3.5 (7 half-cycles)
    localparam MUL2_DIV_CLK = 7;

    reg [2:0] cnt_pos;  // Counter running on rising edge
    reg [2:0] cnt_neg;  // Counter running on falling edge

    // Divided clocks from positive and negative edge counters
    reg div_clk_pos;
    reg div_clk_neg;

    // Counter and output logic on rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos    <= 3'd0;
            div_clk_pos <= 1'b0;
        end else begin
            if (cnt_pos == MUL2_DIV_CLK - 1)
                cnt_pos <= 3'd0;
            else
                cnt_pos <= cnt_pos + 3'd1;

            // Generate div_clk_pos with period 7 cycles: high for 4 cycles, low for 3 cycles
            if (cnt_pos < 4)
                div_clk_pos <= 1'b1;
            else
                div_clk_pos <= 1'b0;
        end
    end

    // Counter and output logic on falling edge
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg    <= 3'd0;
            div_clk_neg <= 1'b0;
        end else begin
            if (cnt_neg == MUL2_DIV_CLK - 1)
                cnt_neg <= 3'd0;
            else
                cnt_neg <= cnt_neg + 3'd1;

            // Generate div_clk_neg with period 7 cycles: high for 3 cycles, low for 4 cycles (phase shifted)
            if (cnt_neg < 3)
                div_clk_neg <= 1'b1;
            else
                div_clk_neg <= 1'b0;
        end
    end

    // Combine both phase shifted clocks by OR to get the fractional clock
    assign clk_div = div_clk_pos | div_clk_neg;

endmodule