module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // increment
                    if (wave == 5'd31) begin
                        state <= 1'b1;  // switch to decrement
                        // hold wave at max to avoid toggling
                        wave <= wave;
                    end else begin
                        wave <= wave + 5'd1;
                    end
                end
                1'b1: begin // decrement
                    if (wave == 5'd0) begin
                        state <= 1'b0;  // switch to increment
                        // hold wave at min to avoid toggling
                        wave <= wave;
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