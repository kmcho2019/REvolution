module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    // Pack inputs into an array for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    integer i, j;
    always @(*) begin
        // Compose the 25-bit output by checking equality of inputs in the specified order
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Calculate the output index from problem statement: out[24 - (5*i + j)]
                out[24 - (5*i + j)] = ~(inputs[4 - i] ^ inputs[4 - j]);
            end
        end
    end
endmodule