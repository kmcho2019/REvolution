module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg dir;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b00000;
        dir <= 0;
    end
    else begin
        if (dir) begin
            wave <= wave - 1;
            if (wave == 5'b00000) dir <= 0;
        end
        else begin
            wave <= wave + 1;
            if (wave == 5'b11111) dir <= 1;
        end
    end
end

endmodule