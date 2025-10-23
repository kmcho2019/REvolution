module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg state;

always @(posedge clk) begin
    if (~rst_n) begin
        state <= 0;
        wave <= 0;
    end else begin
        if (state == 0) begin
            wave <= wave + 1;
            if (wave == 31) begin
                state <= 1;
            end
        end else if (state == 1) begin
            wave <= wave - 1;
            if (wave == 0) begin
                state <= 0;
            end
        end
    end
end

endmodule