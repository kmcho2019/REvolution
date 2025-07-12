module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] int_cnt;  // Integer counter
reg clk_div_int;  // Intermediate divided clock
reg prev_clk_div_int;  // Previous value of clk_div_int

// Sequential logic for integer counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        int_cnt <= 3'b000;
        clk_div_int <= 1'b0;
        prev_clk_div_int <= 1'b0;
    end else begin
        if (int_cnt == MUL2_DIV_CLK - 1) begin
            int_cnt <= 3'b000;
        end else begin
            int_cnt <= int_cnt + 1'b1;
        end
        // Generate divided clock for 4 out of 7 cycles
        if (int_cnt == 3'b000 || int_cnt == 3'b001 || int_cnt == 3'b010 || int_cnt == 3'b011) begin
            clk_div_int <= 1'b1;  // Set divided clock for the first 4 cycles
        end else begin
            clk_div_int <= 1'b0;  // Reset divided clock for the remaining cycles
        end
        // Store previous value of clk_div_int
        prev_clk_div_int <= clk_div_int;
    end
end

// Combinational logic for final fractional divided clock output
// To achieve a uniform duty cycle, we use both the current and previous
// values of the divided clock signal, effectively creating a phase-shifted version.
assign clk_div = (clk_div_int || prev_clk_div_int);  // OR the current and previous clocks

endmodule