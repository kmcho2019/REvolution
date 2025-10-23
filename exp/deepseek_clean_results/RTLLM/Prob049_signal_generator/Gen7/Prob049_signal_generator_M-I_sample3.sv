module signal_generator (
    input clk,
    input rst_n,
    input enable,       // Added for power control
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end else if (enable) begin  // Only operate when enabled
        case (state)
            1'b0: begin  // Increment state
                wave <= wave + 1;
                if (&wave) state <= 1'b1;  // Check all bits set (31)
            end
            1'b1: begin  // Decrement state
                wave <= wave - 1;
                if (~|wave) state <= 1'b0;  // Check all bits clear (0)
            end
        endcase
    end
end

endmodule