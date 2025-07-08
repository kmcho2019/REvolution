module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum_ext;

    // Extend inputs to 9 bits by sign extension to capture carry out
    assign sum_ext = {a[7], a} + {b[7], b};

    assign s = sum_ext[7:0];

    // Overflow detection:
    // overflow = carry into MSB XOR carry out of MSB
    // carry into MSB = sum_ext[7] (sign bit of sum)
    // carry out of MSB = sum_ext[8] (9th bit)
    assign overflow = sum_ext[8] ^ sum_ext[7];

endmodule