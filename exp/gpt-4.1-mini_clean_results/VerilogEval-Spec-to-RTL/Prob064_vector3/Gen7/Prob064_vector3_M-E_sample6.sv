module TopModule(
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Construct w by concatenating a and upper 3 bits of b
    assign w = {a, b[4:2]};

    // Construct x by concatenating lower 2 bits of b and upper 6 bits of c (pad c's bits)
    // Since c is 5 bits, pad with zero on MSB to get 6 bits: {1'b0, c}
    assign x = {b[1:0], 1'b0, c[4:0]}; // total 2+1+5=8 bits

    // Construct y by concatenating d and upper 3 bits of e
    assign y = {d, e[4:2]};

    // Construct z by concatenating lower 2 bits of e, f, and appended two bits (2'b11)
    assign z = {e[1:0], f, 2'b11}; // 2 + 5 + 2 = 9 bits, so take only 8 bits from concatenation

    // But z is 8 bits: so we must trim one bit from concatenation:
    // Let's assign lower 2 bits of e (2 bits), f (5 bits), plus 2 appended bits (2 bits) total 9 bits,
    // To fit 8 bits, discard highest bit from f:
    // Use f[4:0], so remove f[4] to get f[3:0] which is 4 bits, total now 2 + 4 + 2 = 8 bits

    // So revise z assignment:
    // assign z = {e[1:0], f[3:0], 2'b11};

endmodule