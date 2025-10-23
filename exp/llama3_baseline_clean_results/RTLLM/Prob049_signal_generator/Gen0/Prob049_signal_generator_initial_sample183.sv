module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // 1-bit state register

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Clear state register
        wave <= 0; // Clear wave register
    end else begin // Normal operation
        case (state)
            0: begin // State 0: Increment waveform
                if (wave == 5'd31) begin // Waveform reaches 31
                    state <= 1; // Transition to state 1
                    wave <= 5'd31; // Hold waveform value
                end else begin
                    wave <= wave + 5'd1; // Increment waveform
                end
            end
            1: begin // State 1: Decrement waveform
                if (wave == 5'd0) begin // Waveform reaches 0
                    state <= 0; // Transition to state 0
                    wave <= 5'd0; // Hold waveform value
                end else begin
                    wave <= wave - 5'd1; // Decrement waveform
                end
            end
            default: begin
                state <= 0; // Default state
                wave <= 0; // Default waveform value
            end
        endcase
    end
end

endmodule