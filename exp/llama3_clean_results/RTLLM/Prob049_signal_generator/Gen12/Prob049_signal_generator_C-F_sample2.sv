module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state; // 0: incrementing, 1: decrementing

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
        state <= 0;
    end else begin
        if (state == 0) begin
            wave <= (wave == 5'd31)? 5'd31 : wave + 1;
            if (wave == 5'd31) begin
                state <= 1;
            end
        end else begin
            wave <= (wave == 5'd0)? 5'd0 : wave - 1;
            if (wave == 5'd0) begin
                state <= 0;
            end
        end
    end
end

endmodule