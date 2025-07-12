module signal_generator(
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [4:0] wave // 5-bit output waveform signal
);

reg [4:0] wave; // 5-bit register to represent the waveform
reg state; // Register to control the state of the waveform generation

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // On reset
        state <= 0; // Clear state to 0
        wave <= 0; // Clear wave to 0
    end else begin // On clock edge
        case (state)
            0: begin // State 0: Increment wave
                wave <= wave + 1; // Increment wave by 1
                if (wave == 31) begin // If wave reaches 31
                    state <= 1; // Transition state to 1
                end
            end
            1: begin // State 1: Decrement wave
                wave <= wave - 1; // Decrement wave by 1
                if (wave == 0) begin // If wave reaches 0
                    state <= 0; // Transition state back to 0
                end
            end
        endcase
    end
end

endmodule