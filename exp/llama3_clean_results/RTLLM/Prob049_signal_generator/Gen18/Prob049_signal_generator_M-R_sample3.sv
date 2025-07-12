module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
        dir <= 0;
    end else begin
        if (dir == 0) begin
            if (wave == 31) begin
                dir <= 1;
                wave <= wave;
            end else begin
                wave <= wave + 1;
            end
        end else begin
            if (wave == 0) begin
                dir <= 0;
                wave <= wave;
            end else begin
                wave <= wave - 1;
            end
        end
    end
end

endmodule