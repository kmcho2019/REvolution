module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        cin,
    output [7:0] sum,
    output       cout
);

    wire [7:0] carry; // internal carry signals between full adders

    // Full adder module
    // Inputs: x, y, cin; Outputs: sum, cout
    // Define it as an internal module here for completeness
    module full_adder (
        input  x,
        input  y,
        input  cin,
        output sum,
        output cout
    );
        assign sum  = x ^ y ^ cin;
        assign cout = (x & y) | (x & cin) | (y & cin);
    endmodule

    // Instantiate 8 full adders
    full_adder fa0(.x(a[0]), .y(b[0]), .cin(cin),      .sum(sum[0]), .cout(carry[0]));
    full_adder fa1(.x(a[1]), .y(b[1]), .cin(carry[0]), .sum(sum[1]), .cout(carry[1]));
    full_adder fa2(.x(a[2]), .y(b[2]), .cin(carry[1]), .sum(sum[2]), .cout(carry[2]));
    full_adder fa3(.x(a[3]), .y(b[3]), .cin(carry[2]), .sum(sum[3]), .cout(carry[3]));
    full_adder fa4(.x(a[4]), .y(b[4]), .cin(carry[3]), .sum(sum[4]), .cout(carry[4]));
    full_adder fa5(.x(a[5]), .y(b[5]), .cin(carry[4]), .sum(sum[5]), .cout(carry[5]));
    full_adder fa6(.x(a[6]), .y(b[6]), .cin(carry[5]), .sum(sum[6]), .cout(carry[6]));
    full_adder fa7(.x(a[7]), .y(b[7]), .cin(carry[6]), .sum(sum[7]), .cout(cout));

endmodule