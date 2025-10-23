module signal_generator (
    input clk,          // Clock signal
    input rst_n,        // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave_reg;  // Internal register for waveform
reg state;           // Internal state register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;       // Reset state to 0 on reset
        wave_reg <= 5'd0; // Reset waveform to 0 on reset
    end else begin
        case (state)
            1'b0: begin
                if (wave_reg == 5'd31) begin
                    state <= 1'b1; // Transition to state 1 when wave reaches 31
                    wave_reg <= 5'd31; // Hold wave at 31
                end else begin
                    wave_reg <= wave_reg + 1; // Increment wave
                end
            end
            1'b1: begin
                if (wave_reg == 5'd0) begin
                    state <= 1'b0; // Transition to state 0 when wave reaches 0
                    wave_reg <= 5'd0; // Hold wave at 0
                end else begin
                    wave_reg <= wave_reg - 1; // Decrement wave
                end
            end
        endcase
    end
end

assign wave = wave_reg; // Continuous assignment of wave_reg to output wave

endmodule