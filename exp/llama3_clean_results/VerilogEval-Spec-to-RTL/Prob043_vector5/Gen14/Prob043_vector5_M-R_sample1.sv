module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    wire [4:0] inputs = {a, b, c, d, e};
    genvar i;
    generate
        for (i = 0; i < 25; i++) begin
            wire [2:0] idx_i = i / 5;
            wire [1:0] idx_j = i % 5;
            assign out[i] = ~(inputs[idx_i] ^ inputs[idx_j]);
        end
    endgenerate
endmodule