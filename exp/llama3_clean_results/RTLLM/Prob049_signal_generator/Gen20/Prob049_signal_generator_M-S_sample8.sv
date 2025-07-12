module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg incrementing;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
        incrementing <= 1;
    end else begin
        if (incrementing) begin
            if (wave == 31) begin
                wave <= wave;
                incrementing <= 0;
            end else begin
                wave <= wave + 1;
            end
        end else begin
            if (wave == 0) begin
                wave <= wave;
                incrementing <= 1;
            end else begin
                wave <= wave - 1;
            end
        end
    end
end

endmodule