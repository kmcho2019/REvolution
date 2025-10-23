// Define a module for an 8-bit full adder
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal wire to carry the carry signal
    wire [7:0] carry;

    // Assign the carry out of each bit to the carry in of the next bit
    assign carry[0] = Cin;
    assign Co = carry[7];

    // Generate the sum and carry for each bit
    generate
        for (genvar i = 0; i < 8; i++) begin
            full_adder fa(
               .a(a[i]),
               .b(b[i]),
               .Cin(carry[i]),
               .y(y[i]),
               .Co(carry[i+1])
            );
        end
    endgenerate

endmodule

// Define a module for a single bit full adder
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

// Define the main module for the 16-bit full adder
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Internal wire to carry the carry signal
    wire carry_out_8bit;

    // Instantiate the 8-bit adder for the lower 8 bits
    adder_8bit adder_lower(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(carry_out_8bit)
    );

    // Instantiate the 8-bit adder for the upper 8 bits
    adder_8bit adder_upper(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(carry_out_8bit),
       .y(y[15:8]),
       .Co(Co)
    );

endmodule