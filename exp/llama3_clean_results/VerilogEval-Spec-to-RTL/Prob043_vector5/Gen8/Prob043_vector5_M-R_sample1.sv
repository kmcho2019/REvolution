module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] signals = {a, b, c, d, e};
integer i;

always @(*) begin
    for (i = 0; i < 25; i++) begin
        out[24 - i] = ~(signals[i / 5] ^ signals[i % 5]);
    end
end

endmodule