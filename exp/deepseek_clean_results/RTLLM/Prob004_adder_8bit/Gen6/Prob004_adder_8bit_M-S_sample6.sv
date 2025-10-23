module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire [8:0] carry = {1'b0, a} + {1'b0, b} + cin;
    assign sum = carry[7:0];
    assign cout = carry[8];

endmodule