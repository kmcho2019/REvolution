module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum_raw = A + B + Cin;
    wire overflow = (sum_raw > 9);
    wire [4:0] sum_corrected = overflow ? sum_raw + 6 : sum_raw;

    assign Sum = sum_corrected[3:0];
    assign Cout = sum_corrected[4];
    
endmodule