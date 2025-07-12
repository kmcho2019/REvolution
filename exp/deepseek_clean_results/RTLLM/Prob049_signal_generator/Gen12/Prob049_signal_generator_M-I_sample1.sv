module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'd0;
        state <= 1'b0;
    end else begin
        // Wave update
        if (state == 0) begin
            wave <= wave + 1'b1;
        end else begin
            wave <= wave - 1'b1;
        end
        
        // State transition
        if (state == 0 && wave == 30) begin  // Will be 31 next cycle
            state <= 1'b1;
        end else if (state == 1 && wave == 1) begin  // Will be 0 next cycle
            state <= 1'b0;
        end
    end
end

endmodule