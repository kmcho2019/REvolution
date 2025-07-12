module signal_generator(
    input clk,         // Clock signal
    input rst_n,       // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave_reg;   // Register to hold the waveform value
reg state;           // Register to hold the state (0 for incrementing, 1 for decrementing)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;   // Reset state to 0
        wave_reg <= 0; // Reset waveform to 0
    end else begin
        case (state)
            0: begin  // Incrementing state
                wave_reg <= wave_reg + 1;  // Increment waveform
                if (wave_reg == 31) begin // Check if waveform has reached 31
                    state <= 1;           // Transition to decrementing state
                end
            end
            1: begin  // Decrementing state
                wave_reg <= wave_reg - 1;  // Decrement waveform
                if (wave_reg == 0) begin   // Check if waveform has reached 0
                    state <= 0;            // Transition back to incrementing state
                end
            end
            default: begin
                state <= 0;                // Default state
                wave_reg <= 0;             // Default waveform value
            end
        endcase
    end
end

assign wave = wave_reg;  // Assign waveform register value to output

endmodule