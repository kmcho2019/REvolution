module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [4:0] signals;
reg [24:0] out_reg;

always @(*) begin
    signals = {a, b, c, d, e};
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            if (i <= j) begin
                out_reg[i*5 + j] = (signals[i] == signals[j]);
            end else begin
                out_reg[i*5 + j] = out_reg[j*5 + i];
            end
        end
    end
    out = out_reg;
end

endmodule