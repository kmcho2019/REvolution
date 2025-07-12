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

// Generate all pairwise comparisons using shift registers and bitwise XOR
genvar i, j;
generate
    for (i = 0; i < 5; i++) begin
        for (j = 0; j < 5; j++) begin
            // Use XOR and inversion to compare signals
            assign out[i*5 + j] = ~(signals[i] ^ signals[j]);
        end
    end
endgenerate

endmodule