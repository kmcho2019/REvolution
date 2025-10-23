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

// Define the module for a 4-bit full adder using a generate block
module adder_4bit(
    input [3:0] a,
    input [3:0] b,
    input Cin,
    output [3:0] y,
    output Co
);
    // Internal signal for carry
    wire [3:0] carry;

    // First bit (bit 0) adder
    adder_1bit adder_bit0(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y[0]),
        .Co(carry[0])
    );

    // Bits 1 to 3 adders
    genvar i;
    generate
        for (i = 1; i < 4; i++) begin
            adder_1bit adder_bit(
                .a(a[i]),
                .b(b[i]),
                .Cin(carry[i-1]),
                .y(y[i]),
                .Co(carry[i])
            );
        end
    endgenerate

    // Assign Co
    assign Co = carry[3];
endmodule

// Define the module for an 8-bit full adder using two 4-bit adders
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    wire C1;

    // Instantiate two 4-bit adders
    adder_4bit adder_ls(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(C1)
    );

    adder_4bit adder_ms(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(C1),
        .Co(Co),
        .y(y[7:4])
    );
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire C1;

    // Instantiate two 8-bit adders
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule