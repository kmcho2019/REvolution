module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    integer i, j;
    reg [4:0] inputs;
    assign inputs[0] = a;
    assign inputs[1] = b;
    assign inputs[2] = c;
    assign inputs[3] = d;
    assign inputs[4] = e;

    always @(*) begin
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                out[i*5 + j] = ~(inputs[i]) ^ inputs[j];
            end
        end
    end

endmodule