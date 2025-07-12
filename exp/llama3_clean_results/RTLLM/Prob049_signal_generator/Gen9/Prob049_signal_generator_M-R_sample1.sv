module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
        direction <= 0;
    end else begin
        if (direction == 0) begin
            if (wave == 31) begin
                direction <= 1;
            end
            wave <= wave + 1;
        end else begin
            if (wave == 0) begin
                direction <= 0;
            end
            wave <= wave - 1;
        end
    end
end

endmodule