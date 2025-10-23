module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter for 3.5x division
reg [4:0] phase_acc;  // Phase accumulator for phase-shifting
reg [4:0] delta_sigma_out;  // Output of delta-sigma modulator
reg vco_clk;  // Output of VCO
reg vco_clk_div;  // Divided clock output of VCO

// Delta-sigma modulator
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        delta_sigma_out <= 5'b00000;
    end else begin
        // Accumulate fractional part of frequency ratio
        if (delta_sigma_out < 5'b10000) begin
            delta_sigma_out <= delta_sigma_out + 5'b00001;
        end else begin
            delta_sigma_out <= 5'b00000;
        end
    end
end

// VCO
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        vco_clk <= 1'b0;
    end else begin
        // Generate VCO output based on delta-sigma output
        if (delta_sigma_out < 5'b10000) begin
            vco_clk <= 1'b1;
        end else begin
            vco_clk <= 1'b0;
        end
    end
end

// Clock divider
always @(posedge vco_clk or negedge rst_n) begin
    if (~rst_n) begin
        vco_clk_div <= 1'b0;
    end else begin
        // Divide VCO output by 2
        if (vco_clk_div == 1'b0) begin
            vco_clk_div <= 1'b1;
        end else begin
            vco_clk_div <= 1'b0;
        end
    end
end

// Final divided clock output
assign clk_div = vco_clk_div;

endmodule