module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [6:0] sum_low;
    wire c6, c7;

    // Add lower 7 bits
    assign {c6, sum_low} = a[6:0] + b[6:0];

    // Add MSB with carry-in from bit 6 addition
    assign {c7, s[7]} = a[7] + b[7] + c6;

    // Final sum lower bits assignment
    assign s[6:0] = sum_low;

    // Overflow occurs if carry into MSB and carry out of MSB differ
    assign overflow = c6 ^ c7;

endmodule