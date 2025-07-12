module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;  // 0 = increment, 1 = decrement

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
        state <= 1'b0;
    end
    else begin
        if (state == 0) begin
            wave <= (wave == 5'b11111) ? wave - 1'b1 : wave + 1'b1;
            state <= (wave == 5'b11111);
        end
        else begin
            wave <= (wave == 5'b00000) ? wave + 1'b1 : wave - 1'b1;
            state <= (wave != 5'b00000);
        end
    end
end

endmodule