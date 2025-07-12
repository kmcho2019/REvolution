// Define a module for the decimal-aware binary addition stage
module decimal_aware_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    // Define the lookup table (LUT) for decimal-aware binary addition
    reg [3:0] sum;
    reg cout;
    always @(*) begin
        {cout, sum} = A + B + Cin;
        if (sum > 9) begin
            sum = sum + 6;
            cout = 1;
        end else begin
            cout = 0;
        end
    end
    assign Sum = sum;
    assign Cout = cout;
endmodule

// Top-level module for the 4-bit BCD adder
module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    // Instantiate the decimal-aware binary addition stage
    decimal_aware_adder u_add(
       .A(A),
       .B(B),
       .Cin(Cin),
       .Sum(Sum),
       .Cout(Cout)
    );
endmodule