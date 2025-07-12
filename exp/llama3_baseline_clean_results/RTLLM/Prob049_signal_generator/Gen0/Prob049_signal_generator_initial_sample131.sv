module signal_generator (
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave;    // 5-bit register to store the waveform
reg [0:0] state;   // 1-bit register to control the state of the waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the state and waveform registers on reset
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin
                // Increment the waveform if the state is 0
                wave <= wave + 1;
                if (wave == 31) begin
                    // Transition to state 1 if the waveform reaches 31
                    state <= 1;
                end
            end
            1: begin
                // Decrement the waveform if the state is 1
                wave <= wave - 1;
                if (wave == 0) begin
                    // Transition to state 0 if the waveform reaches 0
                    state <= 0;
                end
            end
        endcase
    end
end

endmodule