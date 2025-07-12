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

// Define the module for a 16-bit full adder using 1-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [15:0] carry;
    assign carry[0] = Cin;
    adder_1bit adder_0(
       .a(a[0]),
       .b(b[0]),
       .Cin(carry[0]),
       .y(y[0]),
       .Co(carry[1])
    );
    for (genvar i = 1; i < 15; i++) begin
        adder_1bit adder_i(
           .a(a[i]),
           .b(b[i]),
           .Cin(carry[i]),
           .y(y[i]),
           .Co(carry[i+1])
        );
    end
    adder_1bit adder_15(
       .a(a[15]),
       .b(b[15]),
       .Cin(carry[15]),
       .y(y[15]),
       .Co(Co)
    );
endmodule