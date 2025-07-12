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

// Initialize an intermediate wire array to hold the comparison results
wire [4:0][4:0] comparisons;

// Use nested generate blocks to create the comparator matrix
genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            // Compare signals using XOR and negation for equality check
            assign comparisons[i][j] = ~(signals[i] ^ signals[j]);
        end
    end
endgenerate

// Assign the comparison results to the output vector
genvar k;
generate
    for (k = 0; k < 25; k++) begin
        assign out[k] = comparisons[k / 5][k % 5];
    end
endgenerate

endmodule