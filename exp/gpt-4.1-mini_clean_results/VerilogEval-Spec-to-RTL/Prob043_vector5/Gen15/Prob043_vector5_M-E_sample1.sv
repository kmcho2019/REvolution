module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    // Pack inputs into vector for easy indexing
    wire [4:0] inputs = {a, b, c, d, e};

    integer idx;      // output index 0 to 24
    integer i, j;     // input bit indices 0 to 4

    always @(*) begin
        for (idx = 0; idx < 25; idx = idx + 1) begin
            // Calculate i, j based on output bit index:
            // out[24 - (5*i + j)] corresponds to inputs[4 - i] and inputs[4 - j]
            // Rearranged: idx = 24 - (5*i + j)
            // So: 5*i + j = 24 - idx
            // => i = (24 - idx) / 5, j = (24 - idx) % 5
            i = (24 - idx) / 5;
            j = (24 - idx) % 5;

            out[idx] = ~(inputs[4 - i] ^ inputs[4 - j]); // XNOR
        end
    end
endmodule