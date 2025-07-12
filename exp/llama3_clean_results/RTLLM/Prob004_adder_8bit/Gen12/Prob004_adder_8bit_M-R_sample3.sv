module adder_8bit(
    input   [7:0] a,
    input   [7:0] b,
    input       cin,
    output  [7:0] sum,
    output      cout
);

// Calculate sum and carry-out directly
assign {cout, sum} = a + b + cin;

endmodule