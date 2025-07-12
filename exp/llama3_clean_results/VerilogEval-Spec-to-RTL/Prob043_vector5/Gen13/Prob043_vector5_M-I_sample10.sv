module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    wire [4:0] inputs = {a, b, c, d, e};
    genvar i, j;
    generate
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                assign out[i*5 + j] = ~(inputs[i] ^ inputs[j]); // This line remains the same as it's already optimized for the task
            end
        end
    endgenerate
endmodule