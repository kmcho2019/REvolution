module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

    // Equality check: all bits equal
    wire equal = (A == B);

    // Priority-based comparison from MSB to LSB
    wire greater_bit3 = A[3] & ~B[3];
    wire less_bit3    = ~A[3] & B[3];

    wire greater_bit2 = A[2] & ~B[2];
    wire less_bit2    = ~A[2] & B[2];

    wire greater_bit1 = A[1] & ~B[1];
    wire less_bit1    = ~A[1] & B[1];

    wire greater_bit0 = A[0] & ~B[0];
    wire less_bit0    = ~A[0] & B[0];

    // A_greater if first higher bit where A > B and no previous less condition detected
    assign A_greater =
          greater_bit3
        | (~(greater_bit3 | less_bit3) & greater_bit2)
        | (~(greater_bit3 | less_bit3 | greater_bit2 | less_bit2) & greater_bit1)
        | (~(greater_bit3 | less_bit3 | greater_bit2 | less_bit2 | greater_bit1 | less_bit1) & greater_bit0);

    // A_less if first higher bit where A < B and no previous greater condition detected
    assign A_less =
          less_bit3
        | (~(greater_bit3 | less_bit3) & less_bit2)
        | (~(greater_bit3 | less_bit3 | greater_bit2 | less_bit2) & less_bit1)
        | (~(greater_bit3 | less_bit3 | greater_bit2 | less_bit2 | greater_bit1 | less_bit1) & less_bit0);

    // A_equal if no difference
    assign A_equal = equal;

endmodule