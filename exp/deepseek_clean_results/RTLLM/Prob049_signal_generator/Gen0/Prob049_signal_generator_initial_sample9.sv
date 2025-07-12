module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state; // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Active-low reset: clear everything
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        case (state)
            1'b0: begin // Increment state
                if (wave == 5'b11111) begin // Reached max value (31)
                    wave <= wave - 1'b1;
                    state <= 1'b1;
                end else begin
                    wave <= wave + 1'b1;
                end
            end
            1'b1: begin // Decrement state
                if (wave == 5'b00000) begin // Reached min value (0)
                    wave <= wave + 1'b1;
                    state <= 1'b0;
                end else begin
                    wave <= wave - 1'b1;
                end
            end
        endcase
    end
end

endmodule