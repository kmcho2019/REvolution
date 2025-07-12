module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = incrementing, 1 = decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Active-low reset initialization
        wave <= 5'b0;
        state <= 1'b0;
    end else begin
        // Optimized state machine without case statement
        if (state == 0) begin
            if (&wave) begin  // Equivalent to wave == 5'b11111 (31)
                state <= 1'b1;  // Switch to decrement at max value
            end else begin
                wave <= wave + 1'b1;  // Continue incrementing
            end
        end else begin
            if (|wave == 0) begin  // Equivalent to wave == 5'b00000 (0)
                state <= 1'b0;      // Switch to increment at min value
            end else begin
                wave <= wave - 1'b1;  // Continue decrementing
            end
        end
    end
end

endmodule