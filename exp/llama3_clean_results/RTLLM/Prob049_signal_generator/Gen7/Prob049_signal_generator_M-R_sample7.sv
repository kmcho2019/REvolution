module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // 1 for increment, 0 for decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b00000;  // Reset wave to 0
        dir <= 1'b1;  // Initialize direction to increment
    end else begin
        if (dir == 1'b1) begin
            if (wave == 5'b11111) begin
                wave <= 5'b11111;
                dir <= 1'b0;
            end else begin
                wave <= wave + 1'b1;
            end
        end else begin
            if (wave == 5'b00000) begin
                wave <= 5'b00000;
                dir <= 1'b1;
            end else begin
                wave <= wave - 1'b1;
            end
        end
    end
end

endmodule