module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Define a packed array holding the five 4-bit options in order: b, e, a, d, 4'hF
    wire [3:0] rom [0:4];
    assign rom[0] = b;
    assign rom[1] = e;
    assign rom[2] = a;
    assign rom[3] = d;
    assign rom[4] = 4'hF;

    // Cap c at 4 to avoid out-of-bound access
    wire [2:0] idx = (c < 5) ? c[2:0] : 3'd4;

    // Generate one-hot selection signals from idx
    wire [4:0] sel_one_hot = 5'b00001 << idx;

    // Gate each input with its selection to reduce switching
    wire [3:0] gated_b = rom[0] & {4{sel_one_hot[0]}};
    wire [3:0] gated_e = rom[1] & {4{sel_one_hot[1]}};
    wire [3:0] gated_a = rom[2] & {4{sel_one_hot[2]}};
    wire [3:0] gated_d = rom[3] & {4{sel_one_hot[3]}};
    wire [3:0] gated_f = rom[4] & {4{sel_one_hot[4]}};

    assign q = gated_b | gated_e | gated_a | gated_d | gated_f;

endmodule