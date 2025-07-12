module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Define the input signals as a wire array for easier manipulation
wire [4:0] signals = {a, b, c, d, e};

// Define a 5x5 comparison matrix
reg [4:0][4:0] comparison_matrix;

// Use generate blocks to populate the comparison matrix
genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            // Perform the comparison and assign the result to the matrix
            assign comparison_matrix[i][j] = (signals[i] == signals[j]);
        end
    end
endgenerate

// Use another generate block to flatten the matrix into the output vector
genvar k;
generate
    for (k = 0; k < 25; k++) begin
        // Calculate the row and column indices from the flattened index
        wire [2:0] row = k / 5;
        wire [2:0] col = k % 5;
        // Assign the corresponding element from the matrix to the output vector
        assign out[k] = comparison_matrix[row][col];
    end
endgenerate

endmodule