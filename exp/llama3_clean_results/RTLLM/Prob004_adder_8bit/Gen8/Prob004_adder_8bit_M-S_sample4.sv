module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

    // Compute the sum and carry-out directly using Verilog's arithmetic operators
    assign {cout, sum} = a + b + cin;

endmodule