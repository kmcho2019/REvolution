module signal_generator(
    input clk,    // Clock signal
    input rst_n,  // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave_reg;  // Register to hold the waveform value
reg state_reg;      // Register to control the state of the waveform generation

// Assign the output port to the internal register
assign wave = wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, clear both registers to 0
        state_reg <= 0;
        wave_reg <= 0;
    end else begin
        case (state_reg)
            0: begin
                // If the state is 0, increment the waveform
                wave_reg <= wave_reg + 1;
                // If the waveform reaches 31, transition to state 1
                if (wave_reg == 31) begin
                    state_reg <= 1;
                end
            end
            1: begin
                // If the state is 1, decrement the waveform
                wave_reg <= wave_reg - 1;
                // If the waveform reaches 0, transition back to state 0
                if (wave_reg == 0) begin
                    state_reg <= 0;
                end
            end
            default: begin
                // Handle any unexpected state values
                state_reg <= 0;
                wave_reg <= 0;
            end
        endcase
    end
end

endmodule