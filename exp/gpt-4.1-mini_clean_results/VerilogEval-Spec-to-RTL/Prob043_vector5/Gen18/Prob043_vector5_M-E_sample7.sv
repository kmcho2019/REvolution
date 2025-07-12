module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output reg  [24:0] out
);

    // Input array for convenient indexing
    wire [4:0] inputs = {a, b, c, d, e};

    integer i, j;
    reg [4:0] row_comp [0:4];  // Each row holds 5 XNOR comparison bits

    always @(*) begin
        // Compute each row vector: comparison of inputs[i] with all inputs[j]
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                row_comp[i][4 - j] = ~(inputs[i] ^ inputs[j]);  // XNOR
            end
        end

        // Concatenate all rows into out: row_comp[0] is MSB (bits 24:20), row_comp[4] LSB (4:0)
        out = {row_comp[0], row_comp[1], row_comp[2], row_comp[3], row_comp[4]};
    end

endmodule