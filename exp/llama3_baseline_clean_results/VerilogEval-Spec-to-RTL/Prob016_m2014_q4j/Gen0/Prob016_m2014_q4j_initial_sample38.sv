module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

// Internal wire to connect the carry-out of each full adder to the carry-in of the next
wire [2:0] carry;

// Define the full adder module
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

// Instantiate the full adders
full_adder fa0(x[0], y[0], 1'b0, sum[0], carry[0]);
full_adder fa1(x[1], y[1], carry[0], sum[1], carry[1]);
full_adder fa2(x[2], y[2], carry[1], sum[2], carry[2]);
full_adder fa3(x[3], y[3], carry[2], sum[3], sum[4]);

endmodule