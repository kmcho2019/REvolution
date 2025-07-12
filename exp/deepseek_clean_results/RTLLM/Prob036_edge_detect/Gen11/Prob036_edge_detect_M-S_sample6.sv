module edge_detect (
    input clk,
    input a,
    output rise,
    output down
);

reg a_prev;

always @(posedge clk) begin
    a_prev <= a;
end

assign rise = ~a_prev & a;
assign down = a_prev & ~a;

endmodule