module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // 1-bit state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        state <= 0; // Clear state register to 0
        wave <= 0; // Clear wave register to 0
    end else begin
        case (state)
            0: begin // State 0: Increment waveform
                if (wave == 31) begin // If waveform reaches 31
                    state <= 1; // Transition to state 1
                end
                wave <= wave + 1; // Increment waveform by 1
            end
            1: begin // State 1: Decrement waveform
                if (wave == 0) begin // If waveform reaches 0
                    state <= 0; // Transition back to state 0
                end
                wave <= wave - 1; // Decrement waveform by 1
            end
            default: begin
                state <= 0; // Default state is 0
                wave <= 0; // Default wave is 0
            end
        endcase
    end
end

endmodule