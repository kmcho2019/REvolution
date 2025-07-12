module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // State register to control waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Reset state to 0
        wave <= 0; // Reset wave to 0
    end else begin
        case (state)
            0: begin // State 0: Increment wave
                if (wave == 31) begin // Check if wave has reached maximum
                    state <= 1; // Transition to state 1
                    wave <= wave; // Hold wave at maximum
                end else begin
                    wave <= wave + 1; // Increment wave
                end
            end
            1: begin // State 1: Decrement wave
                if (wave == 0) begin // Check if wave has reached minimum
                    state <= 0; // Transition back to state 0
                    wave <= wave; // Hold wave at minimum
                end else begin
                    wave <= wave - 1; // Decrement wave
                end
            end
            default: begin // Default state
                state <= 0; // Reset to state 0
                wave <= 0; // Reset wave to 0
            end
        endcase
    end
end

endmodule