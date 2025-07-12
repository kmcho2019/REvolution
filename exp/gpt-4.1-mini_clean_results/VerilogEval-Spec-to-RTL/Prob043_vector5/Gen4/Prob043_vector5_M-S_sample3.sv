module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};
    integer i, j;
    reg [24:0] out_reg;

    always @* begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                out_reg[(4 - i)*5 + (4 - j)] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end

    assign out = out_reg;
endmodule