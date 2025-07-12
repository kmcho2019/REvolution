// Define a full adder module
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

// TopModule that instantiates full adders
module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] c;

    // Instantiate full adders using a for loop
    full_adder fa0(x[0], y[0], 1'b0, sum[0], c[0]);
    for (genvar i = 1; i < 4; i++) begin
        full_adder fa(full_adder) (
           .a(x[i]),
           .b(y[i]),
           .cin(c[i-1]),
           .sum(sum[i]),
           .cout(c[i])
        );
    end
    assign sum[4] = c[3];

endmodule