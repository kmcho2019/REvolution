module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7; // Counter cycles through 7 clock cycles for 3.5x division

// Internal signals
reg [2:0] counter; // Counter to cycle through 7 clock cycles
reg clk_div_int1; // Intermediate divided clock with 4 source clock cycles
reg clk_div_int2; // Intermediate divided clock with 3 source clock cycles
reg clk_div_int1_phase_shifted; // Phase-shifted version of clk_div_int1
reg clk_div_int2_phase_shifted; // Phase-shifted version of clk_div_int2

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Initialize counter to 0 on reset
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000; // Reset counter after 7 cycles
    end else begin
        counter <= counter + 1'b1; // Increment counter on each clock cycle
    end
end

// Generate intermediate divided clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1 <= 1'b0; // Initialize intermediate clocks to 0 on reset
        clk_div_int2 <= 1'b0;
    end else begin
        if (counter == 3'b100) begin // Generate clk_div_int1 after 4 cycles
            clk_div_int1 <= ~clk_div_int1;
        end
        if (counter == 3'b011) begin // Generate clk_div_int2 after 3 cycles
            clk_div_int2 <= ~clk_div_int2;
        end
    end
end

// Generate phase-shifted versions of intermediate clocks
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div_int1_phase_shifted <= 1'b0; // Initialize phase-shifted clocks to 0 on reset
        clk_div_int2_phase_shifted <= 1'b0;
    end else begin
        if (counter == 3'b101) begin // Delay clk_div_int1 by half a clock period
            clk_div_int1_phase_shifted <= clk_div_int1;
        end
        if (counter == 3'b010) begin // Advance clk_div_int2 by half a clock period
            clk_div_int2_phase_shifted <= clk_div_int2;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0; // Initialize output clock to 0 on reset
    end else begin
        clk_div <= clk_div_int1_phase_shifted | clk_div_int2_phase_shifted; // Logically OR phase-shifted clocks
    end
end

endmodule