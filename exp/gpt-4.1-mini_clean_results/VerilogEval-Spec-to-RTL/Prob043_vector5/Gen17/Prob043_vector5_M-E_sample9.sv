module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};
    reg [24:0] out_reg;

    integer i, j;
    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Compute bit index: out[24 - (i*5 + j)] to match required bit ordering
                out_reg[24 - (i*5 + j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end

    assign out = out_reg;

endmodule