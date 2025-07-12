module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        // Simplified state machine without case statement
        if (state == 0) begin
            if (wave == 5'b11111) begin
                state <= 1'b1;
            end else begin
                wave <= wave + 1'b1;
            end
        end else begin
            if (wave == 5'b00000) begin
                state <= 1'b0;
            end else begin
                wave <= wave - 1'b1;
            end
        end
    end
end

endmodule