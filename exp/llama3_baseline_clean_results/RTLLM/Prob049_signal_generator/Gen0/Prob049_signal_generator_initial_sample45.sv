module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state; // 0 for increment, 1 for decrement

always @(posedge clk, negedge rst_n) begin
    if (~rst_n) begin // Reset
        state <= 0;
        wave <= 0;
    end else begin
        case (state)
            0: begin // Increment state
                if (wave == 5'd31) begin // Check if waveform has reached 31
                    state <= 1;
                end
                wave <= wave + 1;
            end
            1: begin // Decrement state
                if (wave == 5'd0) begin // Check if waveform has reached 0
                    state <= 0;
                end
                wave <= wave - 1;
            end
            default: begin
                state <= 0;
                wave <= 0;
            end
        endcase
    end
end

endmodule