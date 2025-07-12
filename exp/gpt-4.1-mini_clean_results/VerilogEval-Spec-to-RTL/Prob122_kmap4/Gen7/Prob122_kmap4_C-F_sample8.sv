module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);
    // This module implements the 4-input parity function (a ^ b ^ c ^ d)
    // corresponding to the given Karnaugh map.
    // The logic is decomposed into two intermediate XOR operations inside
    // a combinational always block for clarity and explicit combinational behavior.

    reg ab_xor, cd_xor;

    always @(*) begin
        ab_xor = a ^ b;      // XOR of inputs a and b
        cd_xor = c ^ d;      // XOR of inputs c and d
        out = ab_xor ^ cd_xor; // final output is parity of all four inputs
    end

endmodule