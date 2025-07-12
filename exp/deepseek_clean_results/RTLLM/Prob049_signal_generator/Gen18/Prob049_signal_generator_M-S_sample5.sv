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
    end else begin
        if (direction) begin
            wave <= wave - 1;
            if (wave == 5'b0) direction <= 1'b0;
        end else begin
            wave <= wave + 1;
            if (wave == 5'b11111) direction <= 1'b1;
        end
    end
end

endmodule