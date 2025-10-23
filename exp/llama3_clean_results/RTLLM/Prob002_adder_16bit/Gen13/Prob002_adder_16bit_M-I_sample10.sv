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

// Define the module for a 16-bit full adder using a ripple-carry architecture
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal signals for carry
    wire [15:0] carry;

    // Instantiate the least significant 1-bit adder
    adder_1bit adder_ls(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y[0]),
        .Co(carry[0])
    );

    // Instantiate the remaining 1-bit adders
    generate
        for (genvar i = 1; i < 16; i++) begin
            adder_1bit adder(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    // Assign the final carry-out
    assign Co = carry[15];

endmodule