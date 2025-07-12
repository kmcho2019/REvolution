module signal_generator (
    input         clk,       // Clock signal
    input         rst_n,     // Active-low reset signal
    output reg [4:0] wave     // 5-bit output waveform signal
);

reg [0:0] state;             // Register to control the state of waveform generation

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin        // Reset condition
        state <= 0;          // Clear state register to 0
        wave <= 0;           // Clear waveform register to 0
    end else begin
        case (state)
            0: begin        // Incrementing state
                wave <= wave + 1;
                if (wave == 31) begin
                    state <= 1;  // Transition to decrementing state
                end
            end
            1: begin        // Decrementing state
                wave <= wave - 1;
                if (wave == 0) begin
                    state <= 0;  // Transition to incrementing state
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