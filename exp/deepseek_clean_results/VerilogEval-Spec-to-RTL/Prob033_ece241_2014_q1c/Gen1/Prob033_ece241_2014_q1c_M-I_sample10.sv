module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [8:0] sum_ext; // Extended sum to catch carry out

    // Perform the addition with extended sign bit
    assign sum_ext = {a[7], a} + {b[7], b};
    assign s = sum_ext[7:0];

    // Overflow occurs when carry-in to MSB != carry-out of MSB
    assign overflow = sum_ext[8] ^ sum_ext[7];

endmodule