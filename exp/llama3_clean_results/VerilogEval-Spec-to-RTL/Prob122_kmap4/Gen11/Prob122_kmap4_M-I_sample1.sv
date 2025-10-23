module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // The existing solution is already quite efficient.
    // For the sake of exploration, an alternative implementation using AND, OR, and NOT gates could be:
    // assign out = (a ^ b ^ c ^ d);
    // However, given the simplicity and efficiency of the XOR operator, sticking with it is the best approach unless specific synthesis requirements dictate otherwise.

    assign out = a ^ b ^ c ^ d;

endmodule