module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;

    wire [4:0] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    integer i, j, k;
    always @(*)
    begin
        k = 0;
        for (i = 0; i < 5; i = i + 1)
        begin
            for (j = 0; j < 5; j = j + 1)
            begin
                out[24 - k] = ~(inputs[i] ^ inputs[j]);
                k = k + 1;
            end
        end
    end
endmodule