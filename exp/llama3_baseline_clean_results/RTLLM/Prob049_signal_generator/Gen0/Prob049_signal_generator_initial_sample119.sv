module signal_generator (
    input   clk,
    input   rst_n,
    output  reg [4:0] wave
);

reg [0:0] state;  // 1-bit state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 0;  // Clear state on reset
        wave <= 0;   // Clear waveform on reset
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
                    state <= 0;  // Transition to state 0 when waveform reaches 0
                end
            end
            default: begin
                state <= 0;  // Default state
                wave <= 0;
            end
        endcase
    end
end

endmodule