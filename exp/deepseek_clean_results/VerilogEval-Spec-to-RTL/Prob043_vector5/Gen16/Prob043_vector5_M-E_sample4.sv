module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output reg [24:0] out
);

    // Create a 2D array to store all pairwise comparisons
    reg [4:0][4:0] comp_matrix;
    integer i, j;

    always @(*) begin
        // Store inputs in a vector for easier indexing
        reg [4:0] inputs;
        inputs = {a, b, c, d, e};

        // Compute all pairwise comparisons
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                comp_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end

        // Flatten the matrix into the output vector
        // Using reverse order to match original specification
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                out[(4-i)*5 + (4-j)] = comp_matrix[i][j];
            end
        end
    end

endmodule