module edge_detect (
    input clk,
    input rst_n,
    input a,
    output rise,
    output down
);

reg a_prev;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_prev <= 1'b0;
    end
    else begin
        a_prev <= a;
    end
end

assign rise = (~a_prev) & a;
assign down = a_prev & (~a);

endmodule