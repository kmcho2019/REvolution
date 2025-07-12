module signal_generator(
    input           clk,
    input           rst_n,
    output reg [4:0] wave
);
    reg [0:0] state; // 1-bit state register

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin // Active-low reset
            state <= 0; // Reset state to 0
            wave  <= 0; // Reset waveform to 0
        end else begin
            case (state)
                0: begin // Incrementing state
                    wave <= wave + 1;
                    if (wave == 31) begin // Transition to decrementing state when wave reaches 31
                        state <= 1;
                    end
                end
                1: begin // Decrementing state
                    wave <= wave - 1;
                    if (wave == 0) begin // Transition to incrementing state when wave reaches 0
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule