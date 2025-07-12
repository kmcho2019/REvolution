module freq_divbyfrac(
    input clk,
    input rst_n,
    output reg clk_div
);

// Parameters for fractional division
parameter MUL2_DIV_CLK = 7; // Total number of clock cycles for division
parameter DIV_CYCLE_HIGH = 4; // Number of clock cycles for high phase
parameter DIV_CYCLE_LOW = 3; // Number of clock cycles for low phase

// Internal signals
reg [2:0] counter; // Counter to track the clock cycles
reg clk_int_high; // Intermediate clock signal for high phase
reg clk_int_low; // Intermediate clock signal for low phase
reg clk_phase_shift_high; // Phase-shifted high clock signal
reg clk_phase_shift_low; // Phase-shifted low clock signal

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 3'b000; // Reset counter on active low reset
    end else if (counter == MUL2_DIV_CLK - 1) begin
        counter <= 3'b000; // Wrap around counter
    end else begin
        counter <= counter + 1'b1; // Increment counter
    end
end

// Generate intermediate clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_int_high <= 1'b0;
        clk_int_low <= 1'b0;
    end else begin
        if (counter == DIV_CYCLE_HIGH - 1) begin
            clk_int_high <= 1'b1; // Set high phase clock signal
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_int_high <= 1'b0; // Reset high phase clock signal
        end
        
        if (counter == DIV_CYCLE_LOW - 1) begin
            clk_int_low <= 1'b1; // Set low phase clock signal
        end else if (counter == MUL2_DIV_CLK - DIV_CYCLE_LOW) begin
            clk_int_low <= 1'b0; // Reset low phase clock signal
        end
    end
end

// Phase-shifting logic for high and low clock signals
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_phase_shift_high <= 1'b0;
        clk_phase_shift_low <= 1'b0;
    end else begin
        // Delay high phase clock signal by half a clock period
        if (counter == DIV_CYCLE_HIGH) begin
            clk_phase_shift_high <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - 1) begin
            clk_phase_shift_high <= 1'b0;
        end
        
        // Advance low phase clock signal by half a clock period
        if (counter == DIV_CYCLE_LOW - 2) begin
            clk_phase_shift_low <= 1'b1;
        end else if (counter == MUL2_DIV_CLK - DIV_CYCLE_LOW - 1) begin
            clk_phase_shift_low <= 1'b0;
        end
    end
end

// Generate final fractional divided clock output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        // Logically OR the phase-shifted clock signals
        clk_div <= clk_int_high | clk_int_low | clk_phase_shift_high | clk_phase_shift_low;
    end
end

endmodule