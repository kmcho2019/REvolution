module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] input_signals [4:0];
reg [24:0] out_reg;

integer i, j;

always @(*)
begin
    input_signals[0] = {5{a}};
    input_signals[1] = {5{b}};
    input_signals[2] = {5{c}};
    input_signals[3] = {5{d}};
    input_signals[4] = {5{e}};

    out_reg = 0;

    for (i = 0; i < 5; i++)
    begin
        for (j = 0; j < 5; j++)
        begin
            out_reg[(i * 5) + j] = ~(input_signals[i][0] ^ input_signals[j][0]);
        end
    end
end

assign out = out_reg;

endmodule