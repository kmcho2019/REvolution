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
            wave <= (wave == 31) ? 31 : wave + 1;
            if (wave == 31) direction <= 1;
        end else begin
            wave <= (wave == 0) ? 0 : wave - 1;
            if (wave == 0) direction <= 0;
        end
    end
end

endmodule