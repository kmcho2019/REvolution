module TopModule(
    input clk,
    input d,
    output reg q
);

reg master_q;

always @(*)
begin
    if (~clk) master_q = d;
end

always @(posedge clk)
begin
    q <= master_q;
end

endmodule