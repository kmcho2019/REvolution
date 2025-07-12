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

assign rise = rise_reg;
assign down = down_reg;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 1'b0;
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
    end else begin
        rise_reg <= 1'b0;
        down_reg <= 1'b0;
        if (a && !prev_a) begin
            rise_reg <= 1'b1;
        end else if (!a && prev_a) begin
            down_reg <= 1'b1;
        end
        prev_a <= a;
    end
end

endmodule