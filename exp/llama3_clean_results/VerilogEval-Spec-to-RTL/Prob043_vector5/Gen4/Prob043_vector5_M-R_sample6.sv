module TopModule(a, b, c, d, e, out);
    input a, b, c, d, e;
    output [24:0] out;
    reg [24:0] out;

    wire [4:0] inputs [4:0];
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    integer i, j;
    always @(*) begin
        for (i = 0; i <= 4; i = i + 1) begin
            for (j = 0; j <= 4; j = j + 1) begin
                out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end
endmodule