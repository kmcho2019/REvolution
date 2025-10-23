module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

wire [4:0] inputs;
assign inputs = {a, b, c, d, e};

genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = i; j < 5; j++) begin
            if (i == j) begin
                assign out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
            end else begin
                assign out[i*5 + j] = ~(inputs[i] ^ inputs[j]);
                assign out[j*5 + i] = ~(inputs[i] ^ inputs[j]);
            end
        end
    end
endgenerate

endmodule