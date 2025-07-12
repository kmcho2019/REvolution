module TopModule (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

wire [8:0] sum;

// Calculate the sum
assign sum = {a[7], a} + {b[7], b};

// Assign the sum to the output
assign s = sum[7:0];

// Check for overflow
assign overflow = (a[7] == b[7] && a[7] != sum[8]);

endmodule