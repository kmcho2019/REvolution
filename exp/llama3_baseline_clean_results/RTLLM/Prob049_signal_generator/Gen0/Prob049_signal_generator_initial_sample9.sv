module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [0:0] state; // state register

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        state <= 0; // Clear state register
        wave <= 0; // Clear waveform register
    end else begin
        case (state)
            0: begin // Increment waveform
                wave <= wave + 1;
                if (wave == 31) begin // Transition to decrement state
                    state <= 1;
                end
            end
            1: begin // Decrement waveform
                wave <= wave - 1;
                if (wave == 0) begin // Transition to increment state
                    state <= 0;
                end
            end
            default: begin
                state <= 0; // Default state
                wave <= 0; // Default waveform
            end
        endcase
    end
end

endmodule