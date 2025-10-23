module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Single operation for entire addition
    assign {cout, sum} = a + b + cin;

endmodule