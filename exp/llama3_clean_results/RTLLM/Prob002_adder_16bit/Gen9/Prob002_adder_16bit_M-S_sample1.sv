// Define the module for a 1-bit full adder
module adder_1bit(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for an 8-bit full adder using 1-bit adders
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire [7:0] carry;

    // Instantiate the first 1-bit adder
    adder_1bit adder_0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .y(y[0]),
       .Co(carry[0])
    );

    // Instantiate the remaining 1-bit adders
    generate
        for (genvar i = 1; i < 8; i++) begin
            adder_1bit adder_i(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .y(y[i]),
               .Co(carry[i])
            );
        end
    endgenerate

    // Assign the carry-out of the last adder to Co
    assign Co = carry[7];
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_8bit;

    // Instantiate the least significant 8-bit adder
    adder_8bit adder_ls(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(carry_8bit)
    );

    // Instantiate the most significant 8-bit adder
    adder_8bit adder_ms(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(carry_8bit),
       .y(y[15:8]),
       .Co(Co)
    );
endmodule