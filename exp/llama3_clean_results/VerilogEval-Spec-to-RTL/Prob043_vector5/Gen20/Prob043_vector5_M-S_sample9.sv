module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:0] vec;

    always @(*) begin
        vec = {a, b, c, d, e};
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                out[i * 5 + j] = ~(vec[i] ^ vec[j]);
            end
        end
    end

endmodule