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
        if (dir) begin
            wave <= (wave == 5'b11111) ? 5'b11111 : wave + 1'b1;
            if (wave == 5'b11111) dir <= 1'b0;
        end else begin
            wave <= (wave == 5'b00000) ? 5'b00000 : wave - 1'b1;
            if (wave == 5'b00000) dir <= 1'b1;
        end
    end
end

endmodule