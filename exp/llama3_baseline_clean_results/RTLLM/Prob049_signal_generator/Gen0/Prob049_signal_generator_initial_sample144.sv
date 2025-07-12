module signal_generator (
    input           clk,    // Clock signal
    input           rst_n,  // Active-low reset signal
    output reg [4:0] wave   // 5-bit output waveform signal
);

reg [4:0] wave_reg;  // Register to store the current waveform value
reg       state;     // Register to control the state of the waveform generation

// Always block to update the state and wave registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state     <= 0;  // Clear the state register
        wave_reg  <= 0;  // Clear the wave register
    end else begin
        case (state)
            0: begin  // State 0: Increment the waveform
                if (wave_reg == 31) begin  // Check if the waveform has reached the maximum value
                    state     <= 1;  // Transition to state 1
                    wave_reg  <= 31; // Keep the waveform value at 31
                end else begin
                    wave_reg  <= wave_reg + 1;  // Increment the waveform
                end
            end
            1: begin  // State 1: Decrement the waveform
                if (wave_reg == 0) begin  // Check if the waveform has reached the minimum value
                    state     <= 0;  // Transition back to state 0
                    wave_reg  <= 0;  // Keep the waveform value at 0
                end else begin
                    wave_reg  <= wave_reg - 1;  // Decrement the waveform
                end
            end
            default: begin
                state     <= 0;  // Default state
                wave_reg  <= 0;  // Default waveform value
            end
        endcase
    end
end

// Continuous assignment to output the wave register value
assign wave = wave_reg;

endmodule