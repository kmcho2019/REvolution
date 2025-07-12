module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 0;
    end else if (wave == 31) begin
        wave <= wave - 1'b1;
    end else if (wave == 0) begin
        wave <= wave + 1'b1;
    end else if (wave < 31) begin
        wave <= wave + 1'b1;
    end else begin
        wave <= wave - 1'b1;
    end
end

endmodule