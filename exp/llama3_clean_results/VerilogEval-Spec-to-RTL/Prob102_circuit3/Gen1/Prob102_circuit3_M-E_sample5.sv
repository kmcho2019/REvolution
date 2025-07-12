module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg q
);

always @(*) begin
    q = 0;
    if (a) q = q + 1;
    if (b) q = q + 1;
    if (c) q = q + 1;
    if (d) q = q + 1;
    q = (q >= 2)? 1 : 0;
end

endmodule