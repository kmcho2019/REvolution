module freq_divbyfrac(
    input clk,      // Input clock signal
    input rst_n,     // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for the fractional frequency divider
localparam DIVISOR = 7;  // Divisor for the frequency divider (3.5x division)
localparam PHASE_BITS = 16;  // Number of bits for the phase accumulator

// Signals for the phase accumulator
reg [PHASE_BITS-1:0] phase_accum;  // Phase accumulator
reg [PHASE_BITS-1:0] phase_step;   // Phase step value

// Signal for the clock cycle counter
reg [2:0] cycle_counter;  // Counter for clock cycles

// Signals for duty cycle correction
reg duty_correction;  // Flag for duty cycle correction

// Initialize the phase step value
localparam PHASE_STEP = (1 << (PHASE_BITS - 2));  // Phase step value for 3.5x division

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the phase accumulator and cycle counter
        phase_accum <= 0;
        cycle_counter <= 0;
        duty_correction <= 0;
        clk_div <= 0;
    end else begin
        // Update the phase accumulator
        if (cycle_counter < DIVISOR - 1) begin
            phase_accum <= phase_accum + PHASE_STEP;
            cycle_counter <= cycle_counter + 1;
        end else begin
            phase_accum <= 0;
            cycle_counter <= 0;
        end

        // Duty cycle correction
        if (phase_accum > (1 << (PHASE_BITS - 1))) begin
            duty_correction <= 1;
        end else begin
            duty_correction <= 0;
        end

        // Generate the divided clock signal
        if (duty_correction) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule