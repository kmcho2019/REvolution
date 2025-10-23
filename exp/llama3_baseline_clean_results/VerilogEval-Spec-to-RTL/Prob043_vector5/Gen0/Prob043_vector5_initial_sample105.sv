module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

integer i, j;

always @(*) begin
    for (i = 0; i < 5; i = i + 1) begin
        for (j = 0; j < 5; j = j + 1) begin
            out[5*i + j] = ~(input_signal[i] ^ input_signal[j]);
        end
    end
end

wire [4:0] input_signal = {a, b, c, d, e};

endmodule