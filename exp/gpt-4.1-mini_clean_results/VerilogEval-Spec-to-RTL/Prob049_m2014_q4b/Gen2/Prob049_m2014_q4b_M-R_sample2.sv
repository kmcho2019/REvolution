module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg q_int;

always @(posedge clk) begin
    if (!ar)
        q_int <= d;
end

always @(posedge ar or negedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= q_int;
end

endmodule