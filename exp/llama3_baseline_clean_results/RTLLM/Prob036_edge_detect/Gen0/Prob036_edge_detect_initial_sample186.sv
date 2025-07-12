module edge_detect(
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg prev_a;
reg rise_reg;
reg down_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        prev_a <= a;
        if (a == 1'b1 && prev_a == 1'b0) begin
            rise_reg <= 1'b1;
            down_reg <= 1'b0;
        end else if (a == 1'b0 && prev_a == 1'b1) begin
            rise_reg <= 1'b0;
            down_reg <= 1'b1;
        end else begin
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
        end
    end
end

assign rise = rise_reg;
assign down = down_reg;

endmodule