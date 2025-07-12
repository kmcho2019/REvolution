module signal_generator(
    input clk,      // Clock signal
    input rst_n,   // Active-low reset signal
    output [4:0] wave  // 5-bit output waveform signal
);

reg [4:0] wave;  // 5-bit register for waveform
reg state;      // 1-bit register for state

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin  // Incrementing state
                wave <= wave + 1;
                if (wave == 31) begin  // Transition to decrementing state
                    state <= 1;
                end
            end
            1: begin  // Decrementing state
                wave <= wave - 1;
                if (wave == 0) begin  // Transition to incrementing state
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