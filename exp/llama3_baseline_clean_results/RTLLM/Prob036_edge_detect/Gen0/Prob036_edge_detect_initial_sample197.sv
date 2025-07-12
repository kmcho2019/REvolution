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

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_a <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        prev_a <= a;
        rise_reg <= (prev_a == 0) && (a == 1);
        down_reg <= (prev_a == 1) && (a == 0);
    end
end

assign rise = rise_reg;
assign down = down_reg;

endmodule