module signal_generator(
    input clk,       // Clock signal
    input rst_n,     // Active-low reset signal
    output reg [4:0] wave  // 5-bit output waveform signal
);

reg [0:0] state;  // Register to control the state of the waveform generation

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // Reset condition
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin  // State 0: Increment waveform
                wave <= wave + 1;
                if (wave == 31) begin  // Transition to state 1 when wave reaches 31
                    state <= 1;
                end
            end
            1: begin  // State 1: Decrement waveform
                wave <= wave - 1;
                if (wave == 0) begin  // Transition to state 0 when wave reaches 0
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