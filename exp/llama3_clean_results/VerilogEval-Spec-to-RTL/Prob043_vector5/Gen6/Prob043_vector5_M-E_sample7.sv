module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;
    reg [24:0] out;
    reg [4:0] inp;
    integer i, j;

    always @(*)
    begin
        inp[0] = a;
        inp[1] = b;
        inp[2] = c;
        inp[3] = d;
        inp[4] = e;

        for (i = 0; i < 5; i = i + 1)
        begin
            for (j = 0; j < 5; j = j + 1)
            begin
                out[(i * 5) + j] = ~(inp[i] ^ inp[j]);
            end
        end
    end
endmodule