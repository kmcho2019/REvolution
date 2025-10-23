`timescale 1ns/1ps

module clkgenerator #(
    parameter PERIOD = 10    // Clock period in nanoseconds
) (
    output reg clk = 0       // Generated clock output
);

    // Define states for the clock generator FSM
    typedef enum {HIGH_STATE, LOW_STATE} clk_state_t;
    clk_state_t state = LOW_STATE;
    
    // Calculate half period (handles both even and odd periods)
    localparam HALF_PERIOD = (PERIOD + 1) / 2;  // Round up for odd periods
    
    // State transition timing
    localparam HIGH_TIME = HALF_PERIOD;
    localparam LOW_TIME = PERIOD - HALF_PERIOD;
    
    // Timing counters
    integer high_counter = 0;
    integer low_counter = 0;
    
    // Main state machine
    always begin
        case (state)
            LOW_STATE: begin
                clk <= 0;
                low_counter <= low_counter + 1;
                
                if (low_counter >= LOW_TIME - 1) begin
                    state <= HIGH_STATE;
                    low_counter <= 0;
                end
                #1;  // Simulation time advance
            end
            
            HIGH_STATE: begin
                clk <= 1;
                high_counter <= high_counter + 1;
                
                if (high_counter >= HIGH_TIME - 1) begin
                    state <= LOW_STATE;
                    high_counter <= 0;
                end
                #1;  // Simulation time advance
            end
        endcase
    end
    
    // Initialization and parameter validation
    initial begin
        if (PERIOD < 2) begin
            $display("Error: Period must be >= 2ns");
            $finish;
        end
        $display("State-machine clock generator initialized");
        $display("Period: %0dns (High: %0dns, Low: %0dns)", 
                PERIOD, HIGH_TIME, LOW_TIME);
    end

endmodule