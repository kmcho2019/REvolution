module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    reg [4:0] inputs;

    integer k;
    integer i, j;

    always @(*) begin
        inputs = {a, b, c, d, e};
        for (k = 0; k < 25; k = k + 1) begin
            i = k / 5;
            j = k % 5;
            // out[24] corresponds to k=0 comparing inputs[0], inputs[0], etc.
            out[24 - k] = ~(inputs[i] ^ inputs[j]);
        end
    end

endmodule