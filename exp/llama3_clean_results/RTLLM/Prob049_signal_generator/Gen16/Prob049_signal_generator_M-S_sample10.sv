module signal_generator(
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg direction;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        wave <= 5'd0;
        direction <= 1'b1;
    end else begin
        if (direction == 1'b1) begin
            if (wave == 5'd31) begin
                direction <= 1'b0;
            end
            wave <= wave + 1'd1;
        end else begin
            if (wave == 5'd0) begin
                direction <= 1'b1;
            end
            wave <= wave - 1'd1;
        end
    end
end

endmodule