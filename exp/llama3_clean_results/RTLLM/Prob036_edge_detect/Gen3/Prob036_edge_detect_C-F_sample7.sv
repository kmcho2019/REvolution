module edge_detect(
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg a_prev;
reg rise_reg;
reg down_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_prev <= 0;
        rise_reg <= 0;
        down_reg <= 0;
    end else begin
        a_prev <= a;
        rise_reg <= 0;
        down_reg <= 0;
        
        if (a ^ a_prev) begin
            if (a) begin
                rise_reg <= 1;
            end else begin
                down_reg <= 1;
            end
        end
    end
end

assign rise = rise_reg;
assign down = down_reg;

endmodule