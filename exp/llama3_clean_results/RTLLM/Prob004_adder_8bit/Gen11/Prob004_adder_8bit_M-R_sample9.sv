// Define a module for a full adder
module full_adder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the 8-bit adder module
module adder_8bit #(
    parameter WIDTH = 8
)(
    input   [WIDTH-1:0] a,
    input   [WIDTH-1:0] b,
    input           cin,
    output  [WIDTH-1:0] sum,
    output          cout
);
    // Internal carry signals
    wire [WIDTH:0] carry;
    
    // Initialize the carry-in for the first bit
    assign carry[0] = cin;
    
    // Generate the sum and carry-out for each bit position
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
    
    // The final carry-out of the adder
    assign cout = carry[WIDTH];
endmodule