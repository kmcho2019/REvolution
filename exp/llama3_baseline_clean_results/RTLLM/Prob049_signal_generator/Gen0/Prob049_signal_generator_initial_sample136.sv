module signal_generator(
    input  clk,      // Clock signal
    input  rst_n,    // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [0:0] state;  // 1-bit register to control the state
reg [4:0] wave_reg;  // 5-bit register to represent the waveform

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, clear the state and waveform registers
        state <= 0;
        wave_reg <= 0;
    end else begin
        case (state)
            0: begin
                // Increment the waveform if the state is 0
                wave_reg <= wave_reg + 1;
                if (wave_reg == 5'd31) begin
                    // Transition to state 1 when the waveform reaches 31
                    state <= 1;
                end
            end
            1: begin
                // Decrement the waveform if the state is 1
                wave_reg <= wave_reg - 1;
                if (wave_reg == 5'd0) begin
                    // Transition back to state 0 when the waveform reaches 0
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
                wave_reg <= 0;
            end
        endcase
    end
end

// Assign the output waveform signal
assign wave = wave_reg;

endmodule