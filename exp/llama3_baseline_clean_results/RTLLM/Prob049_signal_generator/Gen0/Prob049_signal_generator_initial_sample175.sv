module signal_generator (
    input  clk,
    input  rst_n,
    output [4:0] wave
);

reg [4:0] wave_reg;  // 5-bit register to hold the waveform value
reg [0:0] state_reg; // 1-bit register to hold the state value (0 or 1)

// Initialize output
assign wave = wave_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, clear state and waveform registers
        state_reg <= 0;
        wave_reg  <= 0;
    end else begin
        case (state_reg)
            0: begin
                // If state is 0, increment waveform by 1
                if (wave_reg == 31) begin
                    // If waveform reaches 31, transition to state 1
                    state_reg <= 1;
                end
                wave_reg <= wave_reg + 1;
            end
            1: begin
                // If state is 1, decrement waveform by 1
                if (wave_reg == 0) begin
                    // If waveform reaches 0, transition back to state 0
                    state_reg <= 0;
                end
                wave_reg <= wave_reg - 1;
            end
            default: begin
                state_reg <= 0;
                wave_reg  <= 0;
            end
        endcase
    end
end

endmodule