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
        // Optimized state machine with boundary holding
        if (state == 0) begin
            if (&wave) begin       // wave == 31 (all bits high)
                state <= 1'b1;     // Switch to decrement state
            end else begin
                wave <= wave + 1;  // Continue incrementing
            end
        end else begin
            if (|wave == 0) begin  // wave == 0 (all bits low)
                state <= 1'b0;     // Switch to increment state
            end else begin
                wave <= wave - 1;  // Continue decrementing
            end
        end
    end
end

endmodule