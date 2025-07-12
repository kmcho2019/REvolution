module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_raw;
    wire       overflow;

    assign sum_raw = A + B + Cin;
    assign overflow = (sum_raw > 5'd9);
    
    // Add correction of 6 if overflow
    wire [4:0] sum_corr = overflow ? (sum_raw + 5'd6) : sum_raw;

    assign Sum = sum_corr[3:0];
    assign Cout = sum_corr[4];
endmodule