module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment wave, 1: decrement wave

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0; // start incrementing
        end else begin
            if (state == 1'b0) begin // incrementing
                if (wave == 5'd31)
                    state <= 1'b1; // switch to decrement
                else
                    wave <= wave + 5'd1;
            end else begin // decrementing
                if (wave == 5'd0)
                    state <= 1'b0; // switch to increment
                else
                    wave <= wave - 5'd1;
            end
        end
    end

endmodule