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
        if (dir == 1'b1) begin  // Incrementing
            if (wave == 5'b11111) begin  // If wave is at maximum
                wave <= 5'b11111;  // Hold at maximum for one cycle
                dir <= 1'b0;  // Switch to decrementing
            end else begin
                wave <= wave + 1'b1;  // Increment wave
            end
        end else begin  // Decrementing
            if (wave == 5'b00000) begin  // If wave is at minimum
                wave <= 5'b00000;  // Hold at minimum for one cycle
                dir <= 1'b1;  // Switch to incrementing
            end else begin
                wave <= wave - 1'b1;  // Decrement wave
            end
        end
    end
end

endmodule