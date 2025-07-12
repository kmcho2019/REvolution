module freq_divbyfrac(
    input  clk,        // Input clock signal
    input  rst_n,      // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to cycle through 7 clock cycles
reg clk_div_long;  // Intermediate divided clock signal with 4 source clock cycles
reg clk_div_short;  // Intermediate divided clock signal with 3 source clock cycles
reg clk_div_long_phase;  // Phase-shifted version of clk_div_long
reg clk_div_short_phase;  // Phase-shifted version of clk_div_short

// Counter to cycle through 7 clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div_long <= 1'b0;
        clk_div_short <= 1'b0;
        clk_div_long_phase <= 1'b0;
        clk_div_short_phase <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1;
        end

        // Generate intermediate divided clock signals
        if (cnt == 3'b000 || cnt == 3'b100) begin
            clk_div_long <= ~clk_div_long;
        end
        if (cnt == 3'b000 || cnt == 3'b011) begin
            clk_div_short <= ~clk_div_short;
        end

        // Phase-shift intermediate divided clock signals
        if (cnt == 3'b001) begin
            clk_div_long_phase <= ~clk_div_long;
        end else if (cnt == 3'b010) begin
            clk_div_long_phase <= clk_div_long;
        end
        if (cnt == 3'b010) begin
            clk_div_short_phase <= ~clk_div_short;
        end else if (cnt == 3'b011) begin
            clk_div_short_phase <= clk_div_short;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        clk_div <= (clk_div_long_phase || clk_div_short_phase);
    end
end

endmodule