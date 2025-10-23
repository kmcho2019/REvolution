module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] inputs;
assign inputs = {a, b, c, d, e};

integer i, j, k;
always @(*) begin
    k = 0;
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            out[k] = ~(inputs[i] ^ inputs[j]);
            k = k + 1;
        end
    end
end

endmodule