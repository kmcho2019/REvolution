module TopModule(
    input clock,
    input a,
    output p,
    output reg q
);

always @(negedge clock) begin
    q <= a;
end

reg q_prev;
always @(posedge clock) begin
    q_prev <= q;
end

assign p = clock && a && ~q_prev;

endmodule