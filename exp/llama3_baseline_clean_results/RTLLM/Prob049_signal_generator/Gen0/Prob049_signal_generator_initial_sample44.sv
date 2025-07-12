module signal_generator(
    input clk,    // Clock signal
    input rst_n,  // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave;  // 5-bit waveform register
reg state;       // State register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition: Clear state and wave registers
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin
                // Increment wave by 1 if state is 0
                wave <= wave + 1;
                // Transition state to 1 if wave reaches 31
                if (wave == 31) begin
                    state <= 1;
                end
            end
            1: begin
                // Decrement wave by 1 if state is 1
                wave <= wave - 1;
                // Transition state to 0 if wave reaches 0
                if (wave == 0) begin
                    state <= 0;
                end
            end
            default: begin
                state <= 0;
                wave <= 0;
            end
        endcase
    end
end

endmodule