module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for PLL
parameter PLL_gain = 16'd100;  // Gain of the PLL
parameter VCO_freq = 32'd100000000;  // Frequency of the VCO
parameter divider_ratio = 32'd3.5;  // Divider ratio (3.5x)

// Internal signals
reg [15:0] pll_error;  // Error signal of the PLL
reg [31:0] vco_freq;  // Frequency of the VCO
reg [31:0] divider_out;  // Output of the fractional-N divider
reg [7:0] dsm_out;  // Output of the delta-sigma modulator
reg clk_div_int;  // Internal clock signal

// PLL
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pll_error <= 16'd0;
        vco_freq <= VCO_freq;
    end else begin
        // Calculate the error signal
        pll_error <= pll_error + (divider_out - VCO_freq);
        
        // Update the VCO frequency
        vco_freq <= vco_freq + (pll_error * PLL_gain);
    end
end

// Fractional-N divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        divider_out <= 32'd0;
    end else begin
        // Calculate the divider output
        divider_out <= divider_out + (vco_freq * divider_ratio);
    end
end

// Delta-sigma modulator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        dsm_out <= 8'd0;
    end else begin
        // Calculate the DSM output
        dsm_out <= dsm_out + (divider_out[7:0] - 8'd3);
    end
end

// Clock divider
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int <= 1'b0;
    end else begin
        // Generate the clock signal
        if (dsm_out >= 8'd4) begin
            clk_div_int <= 1'b1;
        end else begin
            clk_div_int <= 1'b0;
        end
    end
end

// Assign the final output
assign clk_div = clk_div_int;

endmodule