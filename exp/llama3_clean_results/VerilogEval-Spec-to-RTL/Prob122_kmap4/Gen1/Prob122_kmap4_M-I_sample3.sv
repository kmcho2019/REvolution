module TopModule(
    input a,
    input b,
    input c,
    input d,
    output reg out
);

always @(a, b, c, d) begin
    out = (b & d & ~c) | (~a & ~b & c) | (~a & d & c) | (~b & ~c & d);
end

endmodule