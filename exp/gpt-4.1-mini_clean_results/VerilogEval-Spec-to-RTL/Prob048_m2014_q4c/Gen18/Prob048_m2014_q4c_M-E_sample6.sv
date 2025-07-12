module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

reg q_next;

always @(*) begin
    if (r)
        q_next = 1'b0;
    else
        q_next = d;
end

always @(posedge clk) begin
    q <= q_next;
end

endmodule