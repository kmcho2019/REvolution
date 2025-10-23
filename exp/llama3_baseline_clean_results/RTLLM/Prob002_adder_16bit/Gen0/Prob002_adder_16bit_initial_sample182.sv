// Define the 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal wire to carry signal
    wire [7:0] carry;

    // First bit addition
    full_adder fa0(a[0], b[0], Cin, y[0], carry[0]);

    // Subsequent bits additions
    generate
        for (genvar i = 1; i < 8; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    // Last carry out
    assign Co = carry[7];

endmodule

// Define the full adder module for individual bits
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

// Define the 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal wire for carry signal between 8-bit adders
    wire carry_8bit;

    // First 8-bit adder for lower bits
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_8bit)
    );

    // Second 8-bit adder for upper bits
    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_8bit),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule