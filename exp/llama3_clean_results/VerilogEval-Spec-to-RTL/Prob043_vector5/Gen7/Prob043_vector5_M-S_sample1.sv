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

// Use a single generate loop to create all pairwise comparisons
genvar k;
generate
    for (k = 0; k < 25; k++) begin
        // Calculate the pair indices from the loop variable
        wire [2:0] pair_idx = k;
        // Directly compare the signals using the == operator
        assign out[k] = (signals[pair_idx[4:3]] == signals[pair_idx[2:1]]);
    end
endgenerate

endmodule