module signal_generator (
    input             clk,
    input             rst_n,
    output reg [4:0]  wave
);

    reg state; // 0: increment, 1: decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            wave  <= 5'd0;
            state <= 1'b0;
        end else begin
            if (state == 1'b0) begin
                if (wave == 5'd31) begin
                    state <= 1'b1;
                    wave  <= wave - 5'd1;
                end else begin
                    wave <= wave + 5'd1;
                end
            end else begin
                if (wave == 5'd0) begin
                    state <= 1'b0;
                    wave  <= wave + 5'd1;
                end else begin
                    wave <= wave - 5'd1;
                end
            end
        end
    end

endmodule