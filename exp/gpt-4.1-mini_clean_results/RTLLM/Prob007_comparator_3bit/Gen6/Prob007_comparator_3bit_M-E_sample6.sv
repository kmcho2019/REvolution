module comparator_3bit(
    input  wire [2:0] A,
    input  wire [2:0] B,
    output wire       A_greater,
    output wire       A_equal,
    output wire       A_less
);

    // Perform 4-bit subtraction: extend inputs to 4 bits to handle borrow
    wire [3:0] diff = {1'b0, A} - {1'b0, B};

    // Zero detection: all bits of diff are zero means equality
    wire zero = ~( |diff );

    // Sign bit of diff indicates if A < B (1) or A >= B (0)
    wire sign = diff[3];

    // Assign outputs based on subtraction results
    assign A_equal   = zero;
    assign A_less    = ~zero & sign;
    assign A_greater = ~zero & ~sign;

endmodule