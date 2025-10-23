module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    reg [4:0] inputs_vec;

    integer i, j;
    always @(*) begin
        inputs_vec = {a, b, c, d, e};
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Calculate output index as defined: out[24 - (i*5 + j)]
                out[24 - (i*5 + j)] = ~(inputs_vec[i] ^ inputs_vec[j]);
            end
        end
    end
endmodule