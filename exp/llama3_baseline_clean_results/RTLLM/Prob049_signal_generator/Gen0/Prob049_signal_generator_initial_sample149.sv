module signal_generator(
    input clk, 
    input rst_n, 
    output [4:0] wave
);

reg [4:0] wave_reg; // Register to hold the waveform value
reg state_reg;      // Register to control the state of waveform generation
reg [4:0] next_wave; // Next value of the waveform

assign wave = wave_reg; // Assign the output wave to the waveform register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state_reg <= 0;
        wave_reg <= 0;
    end else begin // Normal operation
        case (state_reg)
            0: begin // State 0: Increment the waveform
                if (wave_reg == 5'd31) begin // Check if waveform has reached 31
                    state_reg <= 1; // Transition to state 1
                    wave_reg <= 5'd31; // Keep waveform at 31
                end else begin
                    wave_reg <= wave_reg + 1; // Increment the waveform
                end
            end
            1: begin // State 1: Decrement the waveform
                if (wave_reg == 5'd0) begin // Check if waveform has reached 0
                    state_reg <= 0; // Transition back to state 0
                    wave_reg <= 5'd0; // Keep waveform at 0
                end else begin
                    wave_reg <= wave_reg - 1; // Decrement the waveform
                end
            end
            default: begin
                state_reg <= 0;
                wave_reg <= 0;
            end
        endcase
    end
end

endmodule