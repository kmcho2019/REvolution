module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [2:0] pll_cnt;  // Counter to track PLL clock cycles
reg pll_clk;  // PLL output clock signal
reg dcm_clk;  // DCM output clock signal
reg phase_shift;  // Phase-shifting signal

// PLL logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pll_cnt <= 3'b000;  // Reset PLL counter
    end else begin
        // Increment PLL counter
        if (pll_cnt == MUL2_DIV_CLK - 1) begin
            pll_cnt <= 3'b000;
        end else begin
            pll_cnt <= pll_cnt + 1'b1;
        end
    end
end

// Generate PLL output clock signal
always @(*) begin
    case (pll_cnt)
        3'b000, 3'b001, 3'b002, 3'b003, 3'b004, 3'b005, 3'b006: begin
            pll_clk = 1'b1;  // PLL output clock signal
        end
        default: begin
            pll_clk = 1'b0;
        end
    endcase
end

// DCM logic
always @(posedge pll_clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;  // Reset DCM counter
    end else begin
        // Increment DCM counter
        if (cnt == 2'd1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate DCM output clock signal
always @(*) begin
    case (cnt)
        2'd0: begin
            dcm_clk = 1'b1;  // DCM output clock signal
        end
        default: begin
            dcm_clk = 1'b0;
        end
    endcase
end

// Phase-shifting logic
always @(posedge pll_clk) begin
    phase_shift <= ~phase_shift;  // Phase-shifting signal
end

// Output logic
assign clk_div = (dcm_clk && phase_shift) || (dcm_clk && ~phase_shift);

endmodule