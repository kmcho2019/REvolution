module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

parameter MUL2_DIV_CLK = 7;  // Total clock cycles for fractional division (e.g., 3.5x = 7)
parameter MUL2_DIV_NUM1 = 4; // First divided clock period
parameter MUL2_DIV_NUM2 = 3; // Second divided clock period

reg [2:0] cnt;  // Counter to track the clock cycles
reg div_clk1, div_clk2;  // Intermediate divided clocks
reg div_clk1_dly, div_clk2_adv;  // Phase-shifted versions of the divided clocks

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 3'b000;
        div_clk1 <= 1'b0;
        div_clk2 <= 1'b0;
        div_clk1_dly <= 1'b0;
        div_clk2_adv <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end

        // Generate intermediate divided clocks
        if (cnt == MUL2_DIV_NUM1 - 1 || cnt == MUL2_DIV_CLK - 1) begin
            div_clk1 <= ~div_clk1;
        end
        if (cnt == MUL2_DIV_NUM2 - 1 || cnt == MUL2_DIV_CLK - 1) begin
            div_clk2 <= ~div_clk2;
        end

        // Generate phase-shifted versions of the divided clocks
        div_clk1_dly <= div_clk1;
        div_clk2_adv <= div_clk2;
    end
end

// Generate the final fractional divided clock output
assign clk_div = div_clk1_dly | div_clk2_adv;

endmodule