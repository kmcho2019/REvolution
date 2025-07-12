module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    reg [4:4] inputs;
    reg [4:4] inputs_transposed;
    reg [4:4][4:4] comparison_matrix;
    integer i, j;

    always @(*) begin
        // Initialize input vector
        inputs = {a, b, c, d, e};

        // Initialize transposed input vector
        inputs_transposed = {a, b, c, d, e};

        // Populate comparison matrix
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                comparison_matrix[i][j] = ~(inputs[i] ^ inputs_transposed[j]);
            end
        end

        // Flatten comparison matrix into output vector
        for (i = 0; i < 5; i++) begin
            for (j = 0; j < 5; j++) begin
                out[(i * 5) + j] = comparison_matrix[i][j];
            end
        end
    end

endmodule