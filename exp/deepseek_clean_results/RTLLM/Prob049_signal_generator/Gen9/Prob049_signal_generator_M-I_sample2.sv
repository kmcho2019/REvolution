module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        if (direction == 0) begin
            if (wave == 5'd30) begin  // Pre-check to avoid extra cycle at 31
                wave <= wave + 1;
                direction <= 1'b1;
            end
            else begin
                wave <= wave + 1;
            end
        end
        else begin
            if (wave == 5'd1) begin  // Pre-check to avoid extra cycle at 0
                wave <= wave - 1;
                direction <= 1'b0;
            end
            else begin
                wave <= wave - 1;
            end
        end
    end
end

endmodule