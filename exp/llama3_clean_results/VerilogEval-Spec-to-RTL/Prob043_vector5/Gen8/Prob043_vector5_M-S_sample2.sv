module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    reg [4:0] vec1;
    reg [4:0] vec2;

    always @(*) begin
        vec1 = {a, b, c, d, e};
        vec2 = {a, b, c, d, e};
        
        for (int i = 0; i < 5; i++) begin
            for (int j = 0; j < 5; j++) begin
                out[i*5 + j] = ~(vec1[i] ^ vec2[j]);
            end
        end
    end
endmodule