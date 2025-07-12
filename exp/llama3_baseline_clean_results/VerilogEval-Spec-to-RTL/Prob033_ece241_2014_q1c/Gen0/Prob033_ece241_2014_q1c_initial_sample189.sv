module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Calculate the 9-bit sum
    wire [8:0] sum = {a[7], a} + {b[7], b};

    // Assign the 8 least significant bits of the sum to s
    assign s = sum[7:0];

    // Check for overflow
    assign overflow = (a[7] == b[7]) && (a[7] != sum[8]);

endmodule