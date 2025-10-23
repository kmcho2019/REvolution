module TopModule (
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output       overflow
);

    // Add the two numbers using a 9-bit adder to detect overflow
    wire [8:0] sum = {a[7], a} + {b[7], b};

    // Assign the lower 8 bits of the sum to the output s
    assign s = sum[7:0];

    // Check if the MSB of the sum has a different sign than the MSBs of both operands
    assign overflow = (a[7] == b[7]) && (a[7] != sum[8]);

endmodule