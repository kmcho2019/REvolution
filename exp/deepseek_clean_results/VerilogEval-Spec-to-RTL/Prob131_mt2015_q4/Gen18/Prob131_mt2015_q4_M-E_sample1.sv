module TemporalTopModule(
    input clk,
    input x,
    input y,
    output reg z
);
    // State registers
    reg [1:0] state;
    reg last_x, last_y;
    
    // Intermediate results
    reg phase1_a, phase1_b;
    reg phase2_or, phase2_and;
    
    // Clock gating control
    wire inputs_changed = (x != last_x) || (y != last_y);
    wire active_clock = clk & inputs_changed;
    
    always @(posedge active_clock) begin
        // Track input changes
        last_x <= x;
        last_y <= y;
        
        // Two-phase computation
        case(state)
            2'b00: begin
                // Phase 1: Compute ModuleA and ModuleB
                phase1_a <= x & ~y;      // ModuleA equivalent
                phase1_b <= ~(x ^ y);    // ModuleB equivalent
                state <= 2'b01;
            end
            2'b01: begin
                // Phase 2: Combine results
                phase2_or <= phase1_a | phase1_b;
                phase2_and <= phase1_a & phase1_b;
                state <= 2'b10;
            end
            2'b10: begin
                // Final output
                z <= phase2_or ^ phase2_and;
                state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
    
    // Initial state
    initial begin
        state = 2'b00;
        last_x = 0;
        last_y = 0;
        z = 1'b1;  // Default output matches waveform
    end
endmodule