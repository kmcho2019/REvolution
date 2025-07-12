module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

wire [4:0] inputs;
assign inputs = {a, b, c, d, e};

reg [24:0] comparisons;

integer i, j;
always @(*) begin
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            comparisons[i*5 + j] = ~(inputs[i] ^ inputs[j]);
        end
    end
end

assign out = comparisons;

endmodule