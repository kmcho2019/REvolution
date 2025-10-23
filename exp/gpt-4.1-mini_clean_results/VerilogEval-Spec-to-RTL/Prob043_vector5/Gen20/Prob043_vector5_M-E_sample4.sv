module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output reg [24:0] out
);
    // Pack inputs in order inputs[0]=a, inputs[1]=b, ..., inputs[4]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare 2D reg for equality matrix
    reg equal_matrix [0:4][0:4];

    integer i, j;

    always @(*) begin
        // Compute upper triangle and diagonal
        for (i = 0; i < 5; i = i + 1) begin
            for (j = i; j < 5; j = j + 1) begin
                equal_matrix[i][j] = ~(inputs[i] ^ inputs[j]);
            end
        end

        // Fill lower triangle by symmetry
        for (i = 1; i < 5; i = i + 1) begin
            for (j = 0; j < i; j = j + 1) begin
                equal_matrix[i][j] = equal_matrix[j][i];
            end
        end

        // Flatten the matrix into the output vector
        for (i = 0; i < 5; i = i + 1) begin
            for (j = 0; j < 5; j = j + 1) begin
                // Map to output index as per spec: out[24 - (i*5 + j)]
                out[24 - (i*5 + j)] = equal_matrix[i][j];
            end
        end
    end

endmodule