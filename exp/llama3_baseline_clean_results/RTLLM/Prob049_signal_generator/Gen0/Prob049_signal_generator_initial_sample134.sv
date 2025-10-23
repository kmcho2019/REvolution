module signal_generator(
    input clk,       // Clock signal
    input rst_n,     // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave;  // 5-bit waveform register
reg state;       // State register (0: increment, 1: decrement)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;     // Reset state to 0
        wave <= 0;      // Reset waveform to 0
    end else begin
        case (state)
            0: begin
                wave <= wave + 1;  // Increment waveform
                if (wave == 5'd31) begin
                    state <= 1;    // Transition to decrement state
                end
            end
            1: begin
                wave <= wave - 1;  // Decrement waveform
                if (wave == 0) begin
                    state <= 0;    // Transition to increment state
                end
            end
            default: begin
                state <= 0;         // Default state
                wave <= 0;          // Default waveform
            end
        endcase
    end
end

endmodule