module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;
    reg [4:0] vec1, vec2;
    reg [24:0] result;

    assign vec1 = {a, b, c, d, e};
    assign vec2 = {a, b, c, d, e};

    always @(*) begin
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                result[i*5 + j] = ~(vec1[i] ^ vec2[j]);
            end
        end
    end

    assign out = result;
endmodule