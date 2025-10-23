module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    // Calculate the sum and carry using Verilog's built-in addition
    // The + operator automatically handles carry propagation for us
    assign {Co, y} = a + b + Cin;

endmodule