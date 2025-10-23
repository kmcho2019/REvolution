module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end else begin
        if (wave == 5'b0) begin
            direction <= 1'b0;  // At 0, always increment
            wave <= wave + 1'b1;
        end else if (wave == 5'b11111) begin
            direction <= 1'b1;  // At 31, always decrement
            wave <= wave - 1'b1;
        end else begin
            wave <= direction ? (wave - 1'b1) : (wave + 1'b1);
        end
    end
end

endmodule