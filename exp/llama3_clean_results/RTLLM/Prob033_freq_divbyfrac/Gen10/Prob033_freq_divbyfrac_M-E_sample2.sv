module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] int_cnt;  // Integer counter
reg [1:0] frac_cnt;  // Fractional counter
reg clk_div_int;  // Intermediate divided clock
reg clk_div_phase1;  // Phase-shifted divided clock (delayed)
reg clk_div_phase2;  // Phase-shifted divided clock (advanced)

// Sequential logic for integer counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        int_cnt <= 3'b000;
        frac_cnt <= 2'b00;
        clk_div_int <= 1'b0;
        clk_div_phase1 <= 1'b0;
        clk_div_phase2 <= 1'b0;
    end else begin
        if (int_cnt == MUL2_DIV_CLK - 1) begin
            int_cnt <= 3'b000;
            frac_cnt <= 2'b00;
        end else begin
            int_cnt <= int_cnt + 1'b1;
            if (frac_cnt == 2'b11) begin
                frac_cnt <= 2'b00;
            end else begin
                frac_cnt <= frac_cnt + 1'b1;
            end
        end
        // Generate divided clock for 4 out of 7 cycles
        if ((int_cnt < 4) && (frac_cnt == 2'b00)) begin
            clk_div_int <= ~clk_div_int;  // Toggle divided clock
        end
        // Delay and advance divided clock for phase-shifting
        if ((int_cnt == 0) && (frac_cnt == 2'b00)) begin
            clk_div_phase1 <= ~clk_div_int;  // Delayed clock
        end else if ((int_cnt == 3) && (frac_cnt == 2'b00)) begin
            clk_div_phase1 <= 1'b0;  // Reset delayed clock
        end
        if ((int_cnt == 1) && (frac_cnt == 2'b00)) begin
            clk_div_phase2 <= ~clk_div_int;  // Advanced clock
        end else if ((int_cnt == 4) && (frac_cnt == 2'b00)) begin
            clk_div_phase2 <= 1'b0;  // Reset advanced clock
        end
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = (clk_div_phase1 || clk_div_phase2 || clk_div_int) && (int_cnt!= 3'b000);  // OR the phase-shifted clocks and ensure clock is not generated at reset

endmodule