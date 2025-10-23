module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);
    reg [0:0] state; // 1-bit state register

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin // Active-low reset
            state <= 0; // Clear state to 0
            wave <= 0; // Clear waveform to 0
        end else begin
            case (state)
                0: begin // Increment waveform
                    wave <= wave + 1;
                    if (wave == 31) begin // Transition to decrement state when max value reached
                        state <= 1;
                    end
                end
                1: begin // Decrement waveform
                    wave <= wave - 1;
                    if (wave == 0) begin // Transition to increment state when min value reached
                        state <= 0;
                    end
                end
            endcase
        end
    end
endmodule