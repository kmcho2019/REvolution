module signal_generator (
    input clk,    // Clock signal
    input rst_n,  // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave;  // Register for waveform
reg state;       // Register for state control

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;  // Reset state to 0 on reset
        wave <= 0;   // Reset waveform to 0 on reset
    end else begin
        case (state)
            0: begin
                wave <= wave + 1;  // Increment waveform
                if (wave == 31) begin
                    state <= 1;  // Transition to state 1 when waveform reaches 31
                end
            end
            1: begin
                wave <= wave - 1;  // Decrement waveform
                if (wave == 0) begin
                    state <= 0;  // Transition back to state 0 when waveform reaches 0
                end
            end
            default: begin
                state <= 0;  // Default to state 0 for any other condition
                wave <= 0;
            end
        endcase
    end
end

endmodule