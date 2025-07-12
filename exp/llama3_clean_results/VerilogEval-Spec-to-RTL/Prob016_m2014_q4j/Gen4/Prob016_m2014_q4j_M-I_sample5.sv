// Define a full adder module with optimized logic for reduced switching activity
module full_adder(
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    // Using a single expression for sum can help reduce switching activity
    assign sum = a ^ b ^ cin;
    // Using a Karnaugh map or similar method to optimize the carry logic
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// TopModule that instantiates full adders
module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    // Instantiate full adders with carry chain
    wire c1, c2, c3;
    full_adder fa0(x[0], y[0], 1'b0, sum[0], c1);
    full_adder fa1(x[1], y[1], c1, sum[1], c2);
    full_adder fa2(x[2], y[2], c2, sum[2], c3);
    full_adder fa3(x[3], y[3], c3, sum[3], sum[4]);
endmodule