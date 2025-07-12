module TopModule(
    input clk,
    input d,
    output reg q
);

reg internal_q;

always @(posedge clk)
begin
    internal_q <= d;
    q <= internal_q;
end

always @(negedge clk)
begin
    internal_q <= d;
    q <= internal_q;
end

endmodule