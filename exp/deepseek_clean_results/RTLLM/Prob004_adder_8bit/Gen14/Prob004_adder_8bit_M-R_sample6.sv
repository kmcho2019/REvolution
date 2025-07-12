module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry chain as wire array
    wire [8:0] carry;
    assign carry[0] = cin;

    // Majority function for carry calculation
    assign carry[8:1] = (a & b) | (carry[7:0] & (a | b));

    // Sum calculation using bitwise XOR
    assign sum = a ^ b ^ carry[7:0];

    // Final carry out
    assign cout = carry[8];

endmodule