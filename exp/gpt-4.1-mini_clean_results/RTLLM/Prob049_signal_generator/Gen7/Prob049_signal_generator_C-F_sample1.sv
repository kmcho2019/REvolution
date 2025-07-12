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
                1'b0: begin
                    // Increment wave only if not at max
                    if (wave < 5'd31)
                        wave <= wave + 5'd1;
                    else
                        state <= 1'b1; // Switch to decrement state at top boundary
                end
                1'b1: begin
                    // Decrement wave only if not at min
                    if (wave > 5'd0)
                        wave <= wave - 5'd1;
                    else
                        state <= 1'b0; // Switch to increment state at bottom boundary
                end
            endcase
        end
    end

endmodule