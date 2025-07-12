module signal_generator (
    input   clk,          // Clock signal
    input   rst_n,        // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave;           // 5-bit waveform register
reg       state;          // State register (0: increment, 1: decrement)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset state and waveform to 0
        state <= 0;
        wave  <= 0;
    end else begin
        case (state)
            0: begin
                // Increment waveform by 1
                wave <= wave + 1;
                // Transition to state 1 when waveform reaches 31
                if (wave == 5'd31) begin
                    state <= 1;
                end
            end
            1: begin
                // Decrement waveform by 1
                wave <= wave - 1;
                // Transition to state 0 when waveform reaches 0
                if (wave == 0) begin
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
                wave  <= 0;
            end
        endcase
    end
end

endmodule