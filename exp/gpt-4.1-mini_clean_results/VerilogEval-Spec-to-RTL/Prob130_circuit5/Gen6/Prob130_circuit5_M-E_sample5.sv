module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Array of inputs for indices 0 to 4, beyond 4 outputs 4'hF
    wire [3:0] inputs_array [0:4];
    assign inputs_array[0] = b;
    assign inputs_array[1] = e;
    assign inputs_array[2] = a;
    assign inputs_array[3] = d;
    assign inputs_array[4] = 4'hF;

    // Generate q by indexing inputs_array if c<=4 else 4'hF
    assign q = (c <= 4) ? inputs_array[c] : 4'hF;

endmodule