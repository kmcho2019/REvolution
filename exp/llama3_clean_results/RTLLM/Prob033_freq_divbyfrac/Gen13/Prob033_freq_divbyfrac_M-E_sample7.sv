module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt1;  // Counter for 2/7 frequency
reg [2:0] cnt2;  // Counter for 1/7 frequency
reg clk_int1;  // Intermediate clock signal 1
reg clk_int2;  // Intermediate clock signal 2
reg clk_phase1;  // Phase-shifted clock signal 1
reg clk_phase2;  // Phase-shifted clock signal 2

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1 <= 3'b000;
        cnt2 <= 3'b000;
        clk_int1 <= 1'b0;
        clk_int2 <= 1'b0;
    end else begin
        if (cnt1 == MUL2_DIV_CLK - 1) begin
            cnt1 <= 3'b000;
        end else begin
            cnt1 <= cnt1 + 1'b1;
        end
        if (cnt2 == MUL2_DIV_CLK - 1) begin
            cnt2 <= 3'b000;
        end else begin
            cnt2 <= cnt2 + 1'b1;
        end
        // Generate intermediate clock signals
        if (cnt1 == 3'b100) begin
            clk_int1 <= 1'b1;  // Set clock signal at the start of each cycle
        end else if (cnt1 == 3'b011) begin
            clk_int1 <= 1'b0;  // Reset clock signal after 4 cycles
        end
        if (cnt2 == 3'b011) begin
            clk_int2 <= 1'b1;  // Set clock signal at the start of each cycle
        end else if (cnt2 == 3'b100) begin
            clk_int2 <= 1'b0;  // Reset clock signal after 3 cycles
        end
    end
end

// Combinational logic for phase-shifting
assign clk_phase1 = (cnt1 == 3'b011) ? 1'b1 : 1'b0;  // Phase-shift clock signal 1
assign clk_phase2 = (cnt2 == 3'b100) ? 1'b1 : 1'b0;  // Phase-shift clock signal 2

// Combinational logic for final fractional divided clock output
assign clk_div = (clk_int1 || clk_int2 || clk_phase1 || clk_phase2);  // OR the phase-shifted clocks

endmodule