// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] sum;
    assign sum = a + b + Cin;
    assign y = sum[7:0];
    assign Co = (sum > 8'd255) ? 1'b1 : 1'b0;

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [7:0] sum_lo;
    wire Co_lo;
    wire [7:0] sum_hi;
    wire Co_hi;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit u_adder_lo(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_lo),
        .Co(Co_lo)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit u_adder_hi(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_lo),
        .y(sum_hi),
        .Co(Co_hi)
    );

    // Concatenate the results
    assign y = {sum_hi, sum_lo};
    assign Co = Co_hi;

endmodule