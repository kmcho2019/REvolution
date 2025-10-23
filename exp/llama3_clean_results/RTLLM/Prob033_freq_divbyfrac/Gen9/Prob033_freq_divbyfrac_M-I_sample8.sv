module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg clk_div_int;  // Intermediate divided clock
reg clk_div_delayed;  // Delayed intermediate divided clock
reg clk_div_adv;  // Advanced intermediate divided clock

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_int <= 1'b0;
        clk_div_delayed <= 1'b0;
        clk_div_adv <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        // Generate divided clock for 4 out of 7 cycles
        if (cnt < 4) begin
            clk_div_int <= ~clk_div_int;  // Toggle divided clock
        end
        // Delay and advance divided clock for phase-shifting
        if (cnt == 0) begin
            clk_div_delayed <= ~clk_div_int;  // Delayed clock
        end else if (cnt == 3) begin
            clk_div_delayed <= 1'b0;  // Reset delayed clock
        end
        if (cnt == 1) begin
            clk_div_adv <= ~clk_div_int;  // Advanced clock
        end else if (cnt == 4) begin
            clk_div_adv <= 1'b0;  // Reset advanced clock
        end
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = (clk_div_delayed || clk_div_adv || clk_div_int) && (cnt != 3'b000);  // OR the phase-shifted clocks and ensure clock is not generated at reset

endmodule