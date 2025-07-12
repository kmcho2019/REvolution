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

integer i, j;
always @(*) begin
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
        end
    end
end

endmodule