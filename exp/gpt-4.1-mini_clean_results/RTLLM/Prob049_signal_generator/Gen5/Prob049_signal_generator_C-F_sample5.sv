module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment wave, 1: decrement wave

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave <= 5'd0;
        end else begin
            case (state)
                1'b0: begin // incrementing
                    if (wave == 5'd31) begin
                        state <= 1'b1; // switch to decrement next cycle
                        // hold wave at 31 (no update to avoid toggling)
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrementing
                    if (wave == 5'd0) begin
                        state <= 1'b0; // switch to increment next cycle
                        // hold wave at 0 (no update to avoid toggling)
                    end else begin
                        wave <= wave - 5'd1;
                    end
                end
                default: begin
                    state <= 1'b0;
                    wave <= 5'd0;
                end
            endcase
        end
    end

endmodule