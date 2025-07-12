module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles
reg [1:0] phase;  // Phase counter for phase-shifting
reg clk_div_4;  // Divided clock for 4 source clock cycles
reg clk_div_3;  // Divided clock for 3 source clock cycles
reg prev_clk;  // Previous clock value for edge detection

// Sequential logic for counter and phase
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        phase <= 2'b00;
        clk_div_4 <= 1'b0;
        clk_div_3 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
            phase <= phase + 1'b1;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate divided clocks
        if (cnt < 4) begin
            clk_div_4 <= ~clk_div_4;
        end
        if (cnt >= 4) begin
            clk_div_3 <= ~clk_div_3;
        end
        
        prev_clk <= clk;
    end
end

// Combinational logic for final fractional divided clock output
assign clk_div = (phase == 2'b00) ? clk_div_4 : (phase == 2'b01) ? clk_div_3 : 1'b0;

endmodule