module signal_generator (
    input clk,  // Clock signal
    input rst_n,  // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave_reg;  // Internal waveform register
reg state;  // Internal state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;  // Clear state register to 0
        wave_reg <= 0;  // Clear waveform register to 0
    end else begin
        case (state)
            0: begin  // State 0: Increment waveform
                wave_reg <= wave_reg + 1;  // Increment waveform by 1
                if (wave_reg == 31) begin  // Check if waveform reached 31
                    state <= 1;  // Transition to state 1
                end
            end
            1: begin  // State 1: Decrement waveform
                wave_reg <= wave_reg - 1;  // Decrement waveform by 1
                if (wave_reg == 0) begin  // Check if waveform reached 0
                    state <= 0;  // Transition to state 0
                end
            end
        endcase
    end
end

// Continuous assignment to output port
assign wave = wave_reg;

endmodule