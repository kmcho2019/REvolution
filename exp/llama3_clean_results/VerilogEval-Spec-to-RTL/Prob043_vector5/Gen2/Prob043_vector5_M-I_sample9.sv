module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

wire [4:0] inputs = {a, b, c, d, e};

always @(*) begin
    for (int i = 0; i < 5; i++) begin
        for (int j = 0; j < 5; j++) begin
            out[i*5 + j] = (inputs[i] == inputs[j]) ? 1'b1 : 1'b0;
        end
    end
end

endmodule