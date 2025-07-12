module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'd0;
    end else begin
        if (wave == 5'd31) begin
            wave <= wave - 5'd1;
        end else if (wave == 5'd0) begin
            wave <= wave + 5'd1;
        end else if (wave < 5'd16) begin
            wave <= wave + 5'd1;
        end else begin
            wave <= wave - 5'd1;
        end
    end
end

endmodule