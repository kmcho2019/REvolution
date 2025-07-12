// Define the module for a 1-bit full adder
module full_adder(
    input a,
    input b,
    input Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// Define the module for a 16-bit full adder using cascaded 1-bit full adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [15:0] carry;

    // First bit (bit 0) adder
    full_adder adder_0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y[0]),
        .Co(carry[0])
    );

    // Bits 1 to 15 adders
    generate
        for (genvar i = 1; i < 16; i++) begin
            full_adder adder_i(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    // Assign the carry-out of the last adder to the Co output
    assign Co = carry[15];

endmodule