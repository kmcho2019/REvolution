// Define a module for a full adder
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define a module for an n-bit ripple carry adder
module ripple_carry_adder #(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);
    wire [WIDTH:0] carry;

    // Initialize the carry-in for the first full adder
    assign carry[0] = cin;

    // Generate full adders for each bit
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    // Assign the final carry-out
    assign cout = carry[WIDTH];
endmodule

// Define the module for a 16-bit full adder using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] y,
    output co
);
    wire carry_8bit;

    // Instantiate the least significant 8-bit adder
    ripple_carry_adder #(.WIDTH(8)) adder_ls(
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(cin),
        .sum(y[7:0]),
        .cout(carry_8bit)
    );

    // Instantiate the most significant 8-bit adder
    ripple_carry_adder #(.WIDTH(8)) adder_ms(
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_8bit),
        .sum(y[15:8]),
        .cout(co)
    );
endmodule