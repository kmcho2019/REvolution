module freq_divbyfrac(
    input  clk,
    input  rst_n,
    output clk_div
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7; // Total clock cycles for 3.5x division
parameter DIV_CLK_HALF_PERIOD = 4; // Clock cycles for one intermediate clock period
parameter DIV_CLK_PHASE_DELAY = 3; // Clock cycles for the other intermediate clock period

// Internal signals
reg [2:0] cnt; // Counter for clock cycles
reg div_clk_int1; // Intermediate clock signal 1
reg div_clk_int2; // Intermediate clock signal 2
reg div_clk_int1_phase_shifted; // Phase-shifted intermediate clock signal 1
reg div_clk_int2_phase_shifted; // Phase-shifted intermediate clock signal 2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        div_clk_int1 <= 1'b0;
        div_clk_int2 <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end
        
        // Generate intermediate clock signals
        if (cnt == DIV_CLK_HALF_PERIOD - 1) begin
            div_clk_int1 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            div_clk_int1 <= 1'b0;
        end
        
        if (cnt == DIV_CLK_PHASE_DELAY - 1) begin
            div_clk_int2 <= 1'b1;
        end else if (cnt == DIV_CLK_HALF_PERIOD + DIV_CLK_PHASE_DELAY - 1) begin
            div_clk_int2 <= 1'b0;
        end
    end
end

// Phase-shifting logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        div_clk_int1_phase_shifted <= 1'b0;
        div_clk_int2_phase_shifted <= 1'b0;
    end else begin
        // Phase-shift div_clk_int1 by half a clock period (delayed)
        if (cnt == DIV_CLK_HALF_PERIOD / 2) begin
            div_clk_int1_phase_shifted <= div_clk_int1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            div_clk_int1_phase_shifted <= 1'b0;
        end
        
        // Phase-shift div_clk_int2 by half a clock period (advanced)
        if (cnt == DIV_CLK_PHASE_DELAY / 2) begin
            div_clk_int2_phase_shifted <= div_clk_int2;
        end else if (cnt == DIV_CLK_HALF_PERIOD + DIV_CLK_PHASE_DELAY - 1) begin
            div_clk_int2_phase_shifted <= 1'b0;
        end
    end
end

// Final fractional divided clock output
assign clk_div = div_clk_int1_phase_shifted | div_clk_int2_phase_shifted;

endmodule