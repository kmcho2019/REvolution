// Define the module for an 8-bit full adder using a generate block
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    // Internal signal for carry
    wire [7:0] carry;

    // Generate block for each bit of the adder
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin
            // Calculate sum and carry for each bit position
            assign y[i] = (a[i] ^ b[i] ^ (i == 0 ? Cin : carry[i-1]));
            assign carry[i] = (i == 0) ? (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin) :
                                  (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
        end
    endgenerate

    // Assign Co
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