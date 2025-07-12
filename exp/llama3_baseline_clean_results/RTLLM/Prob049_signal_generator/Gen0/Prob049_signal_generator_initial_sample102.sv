module signal_generator(
    input clk,    // Clock signal
    input rst_n,  // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [0:0] state;  // State register to control the state of the waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;   // Clear state register to 0
        wave <= 0;    // Clear wave register to 0
    end else begin
        case (state)
            0: begin  // Incrementing state
                wave <= wave + 1;  // Increment waveform by 1
                if (wave == 31) begin  // Check if waveform has reached 31
                    state <= 1;  // Transition to decrementing state
                end
            end
            1: begin  // Decrementing state
                wave <= wave - 1;  // Decrement waveform by 1
                if (wave == 0) begin  // Check if waveform has reached 0
                    state <= 0;  // Transition to incrementing state
                end
            end
        endcase
    end
end

endmodule