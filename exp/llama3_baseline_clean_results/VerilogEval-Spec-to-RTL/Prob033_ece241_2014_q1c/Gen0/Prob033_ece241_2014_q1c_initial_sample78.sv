module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Perform the addition
    wire [8:0] temp = {a[7], a} + {b[7], b};

    // Assign the lower 8 bits of the result to s
    assign s = temp[7:0];

    // Check for overflow
    assign overflow = temp[8] != a[7] && temp[8] != b[7];

endmodule