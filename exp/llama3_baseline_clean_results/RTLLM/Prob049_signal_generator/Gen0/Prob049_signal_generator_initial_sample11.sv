module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [4:0] wave_reg; // Internal register for waveform
reg state; // State register to control waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Clear state to 0
        wave_reg <= 0; // Clear wave to 0
    end else begin
        case (state)
            0: begin // State 0: Increment waveform
                wave_reg <= wave_reg + 1;
                if (wave_reg == 31) begin // If wave reaches 31, transition to state 1
                    state <= 1;
                end
            end
            1: begin // State 1: Decrement waveform
                wave_reg <= wave_reg - 1;
                if (wave_reg == 0) begin // If wave reaches 0, transition back to state 0
                    state <= 0;
                end
            end
        endcase
    end
end

assign wave = wave_reg; // Assign internal wave register to output

endmodule