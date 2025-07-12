module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wave <= 5'b0;
    end
    else begin
        if (wave == 5'b11111) begin
            wave <= wave - 1'b1;
        end
        else if (wave == 5'b00000) begin
            wave <= wave + 1'b1;
        end
        else begin
            wave <= wave + (wave[4] ? -1'b1 : 1'b1);
        end
    end
end

endmodule