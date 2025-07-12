module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

    // FSM states
    typedef enum {LOW_PHASE, HIGH_PHASE} clk_state_t;
    clk_state_t current_state;
    
    // Duration counters
    reg [31:0] phase_counter;
    
    initial begin
        current_state = LOW_PHASE;
        clk = 0;
        phase_counter = 0;
    end
    
    always begin
        #1;  // Simulation timestep
        
        case (current_state)
            LOW_PHASE: begin
                phase_counter = phase_counter + 1;
                if (phase_counter >= (PERIOD/2)) begin
                    clk = 1;
                    current_state = HIGH_PHASE;
                    phase_counter = 0;
                end
            end
            
            HIGH_PHASE: begin
                phase_counter = phase_counter + 1;
                if (phase_counter >= (PERIOD/2)) begin
                    clk = 0;
                    current_state = LOW_PHASE;
                    phase_counter = 0;
                end
            end
        endcase
    end

endmodule