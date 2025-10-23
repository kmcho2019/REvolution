module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 1'b0;
            wave  <= 5'd0;
        end else begin
            if (state == 1'b0) begin // increment
                if (wave == 5'd31)
                    state <= 1'b1;  // switch to decrement
                else
                    wave <= wave + 5'd1;
            end else begin // decrement
                if (wave == 5'd0)
                    state <= 1'b0;  // switch to increment
                else
                    wave <= wave - 5'd1;
            end
        end
    end

endmodule