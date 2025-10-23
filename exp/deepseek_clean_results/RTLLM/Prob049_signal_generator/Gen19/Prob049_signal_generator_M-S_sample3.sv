module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;  // 0 = up, 1 = down

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        if (direction == 0) begin
            if (wave == 5'b11111) begin
                direction <= 1'b1;
                wave <= wave - 1;
            end
            else begin
                wave <= wave + 1;
            end
        end
        else begin
            if (wave == 5'b00000) begin
                direction <= 1'b0;
                wave <= wave + 1;
            end
            else begin
                wave <= wave - 1;
            end
        end
    end
end

endmodule