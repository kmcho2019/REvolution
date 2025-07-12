module freq_divbyfrac(
    input clk,    // Input clock signal
    input rst_n,  // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

localparam MUL2_DIV_CLK = 7;  // Total number of clock cycles for 3.5x division
localparam DIV_CLK_HIGH = 4;  // Number of clock cycles for the higher period
localparam DIV_CLK_LOW = 3;   // Number of clock cycles for the lower period

reg [2:0] cnt;  // Counter to track the clock cycles
reg clk_int_high;  // Intermediate clock signal for the higher period
reg clk_int_low;   // Intermediate clock signal for the lower period
reg clk_phase_high;  // Phase-shifted clock signal for the higher period
reg clk_phase_low;   // Phase-shifted clock signal for the lower period

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_int_high <= 1'b0;
        clk_int_low <= 1'b0;
        clk_phase_high <= 1'b0;
        clk_phase_low <= 1'b0;
    end else begin
        // Increment the counter
        cnt <= cnt + 1'b1;

        // Generate intermediate clock signals
        if (cnt == 3'b100) begin  // Every 4th clock cycle
            clk_int_high <= ~clk_int_high;
        end
        if (cnt == 3'b011) begin  // Every 3rd clock cycle
            clk_int_low <= ~clk_int_low;
        end

        // Phase-shift the intermediate clock signals
        clk_phase_high <= clk_int_high;
        clk_phase_low <= clk_int_low;

        // Generate the final fractional divided clock output
        clk_div <= clk_phase_high | clk_phase_low;

        // Reset the counter
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end
    end
end

endmodule