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

// Define the module for a 16-bit full adder using 16 1-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [15:0] carry;

    // Instantiate the 1-bit adders and chain them together
    adder_1bit adder_0(
       .a(a[0]),
       .b(b[0]),
       .Cin(Cin),
       .y(y[0]),
       .Co(carry[0])
    );

    generate
        for (genvar i = 1; i < 16; i++) begin
            adder_1bit adder_i(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i-1]),
               .y(y[i]),
               .Co(carry[i])
            );
        end
    endgenerate

    // The carry-out of the last bit is the final Co
    assign Co = carry[15];
endmodule