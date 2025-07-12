module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg phase;  // Phase signal for phase-shifting
reg prev_clk;  // Previous clock value for edge detection
reg clk_div_1, clk_div_2;  // Intermediate divided clocks

// Sequential logic for counter and phase
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        phase <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            phase <= ~phase;
        end else begin
            cnt <= cnt + 1'b1;
        end
        prev_clk <= clk;
    end
end

// Combinational logic for intermediate divided clocks
assign clk_div_1 = (cnt < 4)? 1'b1 : 1'b0;
assign clk_div_2 = (cnt >= 4)? 1'b1 : 1'b0;

// Combinational logic for final fractional divided clock output
assign clk_div = (phase == 1'b0)? clk_div_1 : clk_div_2;

endmodule