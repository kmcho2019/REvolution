module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

// Declare intermediate signals for the sum and overflow
wire [7:0] sum;
wire overflow_temp;

// Perform the addition
assign sum = a + b;

// Calculate the overflow by checking if the sign bits of a, b, and sum are consistent
assign overflow_temp = (a[7] == b[7] && a[7] != sum[7]);

// Assign the result and overflow to the output ports
assign s = sum;
assign overflow = overflow_temp;

endmodule