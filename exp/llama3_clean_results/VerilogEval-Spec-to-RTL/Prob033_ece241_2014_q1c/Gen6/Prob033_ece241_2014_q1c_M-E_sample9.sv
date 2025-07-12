module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Divide the 8-bit numbers into two 4-bit parts
    wire [3:0] a_hi = a[7:4];
    wire [3:0] a_lo = a[3:0];
    wire [3:0] b_hi = b[7:4];
    wire [3:0] b_lo = b[3:0];

    // Perform 4-bit additions
    wire [4:0] sum_lo;
    assign sum_lo = {1'b0, a_lo} + {1'b0, b_lo};

    // Generate carry for the most significant 4-bit addition
    wire carry;
    assign carry = sum_lo[4];

    // Perform the most significant 4-bit addition with carry
    wire [4:0] sum_hi;
    assign sum_hi = {1'b0, a_hi} + {1'b0, b_hi} + {3'b0, carry};

    // Combine the results
    assign s = {sum_hi[3:0], sum_lo[3:0]};

    // Detect overflow based on the carry-out and input signs
    assign overflow = (a_hi[3] == b_hi[3] && a_hi[3]!= sum_hi[3]);

endmodule