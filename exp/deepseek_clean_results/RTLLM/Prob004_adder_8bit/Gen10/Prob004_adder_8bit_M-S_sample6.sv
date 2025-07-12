module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] result = a + b + cin;
    assign sum = result[7:0];
    assign cout = result[8];

endmodule