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
generate
    for (genvar i = 0; i < 5; i++) begin
        for (genvar j = 0; j < 5; j++) begin
            // Directly compare the signals using the == operator and assign to the output vector
            // Reordered to minimize critical path
            assign out[i + j * 5] = (signals[i] == signals[j]);
        end
    end
endgenerate

endmodule