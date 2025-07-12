module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] inputs;
reg [24:0] result;

assign inputs = {a, b, c, d, e};

always @(*) begin
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            result[i*5 + j] = ~(inputs[i] ^ inputs[j]);
        end
    end
end

assign out = result;

endmodule