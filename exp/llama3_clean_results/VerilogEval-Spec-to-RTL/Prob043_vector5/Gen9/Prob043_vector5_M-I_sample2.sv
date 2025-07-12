module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

reg [24:0] out;
reg [4:0] signals = {a, b, c, d, e};

always @(*) begin
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            out[i*5 + j] = (signals[i] == signals[j]) ? 1'b1 : 1'b0;
        end
    end
end

endmodule