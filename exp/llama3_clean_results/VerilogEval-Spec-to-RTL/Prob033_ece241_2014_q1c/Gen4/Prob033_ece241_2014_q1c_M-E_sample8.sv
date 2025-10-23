module TopModule(
    input  [7:0] a,
    input  [7:0] b,
    output [7:0] s,
    output overflow
);

    // Split the 8-bit operands into two 4-bit parts each
    wire [3:0] a_high = a[7:4];
    wire [3:0] a_low = a[3:0];
    wire [3:0] b_high = b[7:4];
    wire [3:0] b_low = b[3:0];

    // Perform the additions on the 4-bit parts
    wire [4:0] sum_low;
    assign sum_low = {1'b0, a_low} + {1'b0, b_low};

    wire [4:0] sum_high;
    assign sum_high = {1'b0, a_high} + {1'b0, b_high} + sum_low[4];

    // Combine the results
    assign s[3:0] = sum_low[3:0];
    assign s[7:4] = sum_high[3:0];

    // Detect overflow by examining the carry-out of the most significant 4-bit addition
    assign overflow = sum_high[4];

endmodule