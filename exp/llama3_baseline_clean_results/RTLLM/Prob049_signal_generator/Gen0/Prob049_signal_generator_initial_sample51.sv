module signal_generator (
    input clk, // Clock signal
    input rst_n, // Active-low reset signal
    output reg [4:0] wave // 5-bit output waveform signal
);

reg [0:0] state; // Register to control the state of the waveform generation

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Clear state register to 0
        wave <= 0; // Clear wave register to 0
    end else begin
        case (state)
            1'b0: begin // State 0: Increment waveform
                if (wave == 5'd31) begin // Check if waveform has reached 31
                    state <= 1'b1; // Transition state to 1
                    wave <= 5'd31; // Waveform remains at 31
                end else begin
                    wave <= wave + 1'b1; // Increment waveform by 1
                end
            end
            1'b1: begin // State 1: Decrement waveform
                if (wave == 5'd0) begin // Check if waveform has reached 0
                    state <= 1'b0; // Transition state to 0
                    wave <= 5'd0; // Waveform remains at 0
                end else begin
                    wave <= wave - 1'b1; // Decrement waveform by 1
                end
            end
            default: begin // Default state (should not occur)
                state <= 1'b0; // Set state to 0
                wave <= 5'd0; // Set waveform to 0
            end
        endcase
    end
end

endmodule