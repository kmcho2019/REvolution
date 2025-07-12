module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum = A + B + Cin;
    wire       corr   = raw_sum > 5'd9;

    // Correct sum by adding 6 when needed
    wire [4:0] corrected = corr ? (raw_sum + 5'd6) : raw_sum;

    assign Sum  = corrected[3:0];
    assign Cout = corrected[4];

endmodule