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
            if (state == 1'b0) begin // Increment mode
                if (wave == 5'd31)
                    state <= 1'b1;    // Switch to decrement next cycle
                else
                    wave <= wave + 5'd1;
            end else if (state == 1'b1) begin // Decrement mode
                if (wave == 5'd0)
                    state <= 1'b0;    // Switch to increment next cycle
                else
                    wave <= wave - 5'd1;
            end else begin
                // Defensive reset for unexpected state values
                state <= 1'b0;
                wave  <= 5'd0;
            end
        end
    end

endmodule