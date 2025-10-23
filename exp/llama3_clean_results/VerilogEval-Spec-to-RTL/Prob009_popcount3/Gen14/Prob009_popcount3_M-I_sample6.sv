module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Use wires to break down the calculation into intermediate steps
    wire sum_ab;
    wire carry_ab;
    wire sum_abc;

    // Calculate the sum of the first two bits
    fulladder fa1(.a(in[0]), .b(in[1]), .cin(1'b0), .sum(sum_ab), .cout(carry_ab));

    // Calculate the final sum by adding the third bit
    fulladder fa2(.a(sum_ab), .b(in[2]), .cin(carry_ab), .sum(sum_abc), .cout());

    // Assign the final sum to the output, considering only the lower 2 bits
    assign out = {sum_abc[1], sum_abc[0]};

endmodule

// Define a full adder module for use in the TopModule
module fulladder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule