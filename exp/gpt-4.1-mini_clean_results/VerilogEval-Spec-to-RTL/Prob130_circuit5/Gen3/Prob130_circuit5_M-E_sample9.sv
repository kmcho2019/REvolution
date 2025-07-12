module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Create a 20-bit vector of concatenated inputs and default 4'hF
    wire [19:0] data = {4'hF, d, a, e, b};

    // Extract 4-bit slice based on c, capped at 4 to prevent out-of-bound selection
    wire [2:0] idx = (c < 4'd5) ? c[2:0] : 3'd4;

    assign q = data >> (idx * 4);

endmodule