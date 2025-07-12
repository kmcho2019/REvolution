module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cycle_cnt;  // Cycle counter
reg clk_div_int;  // Intermediate divided clock
reg clk_div_phase1;  // Phase-shifted divided clock (delayed)
reg clk_div_phase2;  // Phase-shifted divided clock (advanced)

// Sequential logic for cycle counter and divided clock generation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cycle_cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
    end else begin
        if (cycle_cnt == MUL2_DIV_CLK - 1) begin
            cycle_cnt <= 3'b000;
        end else begin
            cycle_cnt <= cycle_cnt + 1'b1;
        end
        // Generate divided clock for 4 out of 7 cycles
        if ((cycle_cnt < 4) && (cycle_cnt != 0)) begin
            clk_div_int <= 1'b1;  // Set divided clock high
        end else begin
            clk_div_int <= 1'b0;  // Set divided clock low
        end
        // Delay and advance divided clock for phase-shifting
        if (cycle_cnt == 1) begin
            clk_div_phase1 <= 1'b1;  // Set delayed clock high
        end else if (cycle_cnt == 5) begin
            clk_div_phase1 <= 1'b0;  // Set delayed clock low
        end
        if (cycle_cnt == 3) begin
            clk_div_phase2 <= 1'b1;  // Set advanced clock high
        end else if (cycle_cnt == 7) begin
            clk_div_phase2 <= 1'b0;  // Set advanced clock low
        end
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = (clk_div_phase1 || clk_div_phase2 || clk_div_int);

endmodule