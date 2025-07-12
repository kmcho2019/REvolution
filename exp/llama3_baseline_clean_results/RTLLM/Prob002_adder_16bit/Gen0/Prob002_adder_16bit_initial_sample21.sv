// Define an 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Calculate the sum and carry-out using the built-in arithmetic operators
    wire [8:0] sum;
    assign sum = {1'b0, a} + {1'b0, b} + Cin;
    assign y = sum[7:0];
    assign Co = sum[8];

endmodule

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Instantiate two 8-bit adders
    wire Cmid;
    adder_8bit u_adder_lo(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(Cmid)
    );

    adder_8bit u_adder_hi(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(Cmid),
       .y(y[15:8]),
       .Co(Co)
    );

endmodule