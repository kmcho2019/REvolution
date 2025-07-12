module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameter for the multiplier (3.5x division)
localparam MUL2_DIV_CLK = 7;

// Signals for counter
reg [2:0] counter;  // Current counter value

// Signals for intermediate clock signals
reg clk_div_4;  // Clock signal with 4 source clock cycles
reg clk_div_3;  // Clock signal with 3 source clock cycles

// Signals for phase-shifting
reg clk_div_4_ph;  // Phase-shifted clock signal with 4 source clock cycles
reg clk_div_3_ph;  // Phase-shifted clock signal with 3 source clock cycles

// Counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'd0;  // Initialize counter to 0
    end else begin
        // Update counter value based on current counter value
        if (counter == MUL2_DIV_CLK - 1) begin
            counter <= 3'd0;
        end else begin
            counter <= counter + 1'b1;
        end
    end
end

// Intermediate clock signal generation
assign clk_div_4 = (counter < 4)? 1'b1 : 1'b0;
assign clk_div_3 = (counter >= 4 && counter < 7)? 1'b1 : 1'b0;

// Phase-shifting
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_4_ph <= 1'b0;  // Initialize phase-shifted clock signal to 0
        clk_div_3_ph <= 1'b0;  // Initialize phase-shifted clock signal to 0
    end else begin
        // Phase-shift the intermediate clock signals
        if (counter == 0) begin
            clk_div_4_ph <= ~clk_div_4;  // Delay by half a clock period
            clk_div_3_ph <= clk_div_3;  // Advance by half a clock period
        end else begin
            clk_div_4_ph <= clk_div_4;  // No phase-shifting
            clk_div_3_ph <= ~clk_div_3;  // No phase-shifting
        end
    end
end

// Clock signal generation
assign clk_div = clk_div_4_ph | clk_div_3_ph;  // Logically OR the phase-shifted intermediate clock signals

endmodule