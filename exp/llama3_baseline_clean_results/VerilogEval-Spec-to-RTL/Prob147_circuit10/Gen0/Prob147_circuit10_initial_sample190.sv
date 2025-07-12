module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

always @(posedge clk) begin
    state <= ~a & ~b & q;
    if (~a & b)
        q <= 1;
    else if (a & b)
        q <= 0;
    else if (~a & ~b)
        q <= 0;
    else if (a & ~b)
        q <= state;
end

endmodule