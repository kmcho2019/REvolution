module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment wave, 1: decrement wave

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: begin // Increment mode
                    if (wave == 5'd31)
                        state <= 1'b1;  // Switch to decrement mode next cycle
                    else
                        wave <= wave + 5'd1;
                end
                1'b1: begin // Decrement mode
                    if (wave == 5'd0)
                        state <= 1'b0;  // Switch to increment mode next cycle
                    else
                        wave <= wave - 5'd1;
                end
                default: begin
                    // Defensive reset state in case of unexpected state values
                    state <= 1'b0;
                    wave  <= 5'd0;
                end
            endcase
        end
    end

endmodule