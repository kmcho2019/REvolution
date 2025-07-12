`timescale 1ns/1ps

module clkgenerator #(
    parameter BASE_PERIOD = 10,        // Base clock period in ns
    parameter MAX_JITTER = 1,          // Maximum jitter in ns (0 for perfect clock)
    parameter INITIAL_PHASE = 0,       // Initial phase offset in ns
    parameter REF_CLK_PERIOD = 1       // Reference clock period (must be <= BASE_PERIOD/2)
) (
    output reg clk,                    // Output clock signal
    input wire ref_clk,                // Reference clock (higher frequency)
    input wire [15:0] new_period,      // Dynamic period adjustment
    input wire update_period,          // Pulse to update period
    input wire enable                  // Enable/disable clock
);

    reg [15:0] period = BASE_PERIOD;
    reg [15:0] counter;
    reg [15:0] jitter_value;
    integer phase_counter;
    reg update_pending;
    reg [15:0] new_period_latched;

    // Jitter generation
    always @(posedge ref_clk) begin
        jitter_value <= $urandom_range(0, 2*MAX_JITTER) - MAX_JITTER;
    end

    // Phase initialization
    initial begin
        phase_counter = INITIAL_PHASE;
        clk = 0;
        counter = 0;
        update_pending = 0;
        new_period_latched = BASE_PERIOD;
    end

    // Period update handling
    always @(posedge ref_clk) begin
        if (update_period) begin
            new_period_latched = (new_period < 2*REF_CLK_PERIOD) ? 
                                2*REF_CLK_PERIOD : new_period;
            update_pending = 1;
        end
    end

    // Main clock generation
    always @(posedge ref_clk) begin
        if (!enable) begin
            clk <= 0;
            counter <= 0;
        end else begin
            // Handle phase offset
            if (phase_counter > 0) begin
                phase_counter <= phase_counter - 1;
            end else begin
                // Normal operation
                if (counter >= (period/2 + jitter_value)) begin
                    clk <= ~clk;
                    counter <= 0;
                    
                    // Apply pending period update at safe transition point
                    if (update_pending && !clk) begin
                        period <= new_period_latched;
                        update_pending <= 0;
                    end
                end else begin
                    counter <= counter + REF_CLK_PERIOD;
                end
            end
        end
    end

    // Parameter validation
    initial begin
        if (BASE_PERIOD < 2*REF_CLK_PERIOD) begin
            $fatal("Error: BASE_PERIOD must be at least 2*REF_CLK_PERIOD");
        end
        if (MAX_JITTER >= BASE_PERIOD/4) begin
            $fatal("Error: MAX_JITTER must be less than 1/4 of BASE_PERIOD");
        end
        if (INITIAL_PHASE >= BASE_PERIOD) begin
            $fatal("Error: INITIAL_PHASE must be less than BASE_PERIOD");
        end
    end

endmodule