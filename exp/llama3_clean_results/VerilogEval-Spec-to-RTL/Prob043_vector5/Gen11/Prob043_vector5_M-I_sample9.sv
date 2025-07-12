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

// Use generate blocks to systematically create all pairwise comparisons
genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            // Directly compare the signals using the == operator for simplicity and potential efficiency
            // Use a temporary wire to reduce switching activity
            wire temp;
            assign temp = signals[i] == signals[j];
            assign out[i*5 + j] = temp;
        end
    end
endgenerate

endmodule