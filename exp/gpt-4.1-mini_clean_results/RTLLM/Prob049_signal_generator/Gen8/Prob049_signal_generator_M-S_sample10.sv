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
            if (state == 1'b0) begin
                wave <= wave + 5'd1;
                if (wave == 5'd31)
                    state <= 1'b1;
            end else begin
                wave <= wave - 5'd1;
                if (wave == 5'd0)
                    state <= 1'b0;
            end
        end
    end

endmodule