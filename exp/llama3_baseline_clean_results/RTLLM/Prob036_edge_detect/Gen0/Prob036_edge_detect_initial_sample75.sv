module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg prev_a;
assign rise = (a == 1'b1) && (prev_a == 1'b0);
assign down = (a == 1'b0) && (prev_a == 1'b1);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        prev_a <= 1'b0;
    end else begin
        prev_a <= a;
    end
end

endmodule