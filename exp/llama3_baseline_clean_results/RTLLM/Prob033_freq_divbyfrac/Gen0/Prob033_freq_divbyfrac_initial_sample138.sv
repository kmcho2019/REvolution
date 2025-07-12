module freq_divbyfrac(
    input clk,        // Input clock signal
    input rst_n,      // Active low reset signal
    output reg clk_div // Fractionally divided clock output
);

// Parameters
parameter MUL2_DIV_CLK = 7; // Divide by 7 for 3.5x division
parameter DIV_CLK_PER1 = 4; // First divided clock period (4 source clock cycles)
parameter DIV_CLK_PER2 = 3; // Second divided clock period (3 source clock cycles)

// Internal signals
reg [2:0] cnt; // Counter to count clock cycles
reg clk_div_int1; // First intermediate divided clock signal
reg clk_div_int2; // Second intermediate divided clock signal
reg clk_div_int1_phase_shifted; // Phase-shifted version of first intermediate divided clock
reg clk_div_int2_phase_shifted; // Phase-shifted version of second intermediate divided clock
reg half_clk; // Half clock period signal

// Counter to count clock cycles
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end
end

// Generate first intermediate divided clock signal (4 source clock cycles)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0;
    end else begin
        if (cnt == DIV_CLK_PER1 - 1) begin
            clk_div_int1 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_int1 <= 1'b0;
        end
    end
end

// Generate second intermediate divided clock signal (3 source clock cycles)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int2 <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - DIV_CLK_PER2) begin
            clk_div_int2 <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            clk_div_int2 <= 1'b0;
        end
    end
end

// Generate half clock period signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        half_clk <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK / 2 - 1) begin
            half_clk <= 1'b1;
        end else if (cnt == MUL2_DIV_CLK - 1) begin
            half_clk <= 1'b0;
        end
    end
end

// Generate phase-shifted versions of intermediate divided clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_phase_shifted <= 1'b0;
        clk_div_int2_phase_shifted <= 1'b0;
    end else begin
        // Delay first intermediate clock by half a clock period
        if (half_clk && clk_div_int1) begin
            clk_div_int1_phase_shifted <= 1'b1;
        end else if (~half_clk && ~clk_div_int1) begin
            clk_div_int1_phase_shifted <= 1'b0;
        end
        
        // Advance second intermediate clock by half a clock period
        if (half_clk && ~clk_div_int2) begin
            clk_div_int2_phase_shifted <= 1'b1;
        end else if (~half_clk && clk_div_int2) begin
            clk_div_int2_phase_shifted <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the two phase-shifted intermediate clocks
        clk_div <= clk_div_int1_phase_shifted | clk_div_int2_phase_shifted;
    end
end

endmodule