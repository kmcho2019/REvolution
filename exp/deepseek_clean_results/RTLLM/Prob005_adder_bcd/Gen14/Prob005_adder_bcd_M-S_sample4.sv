module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // First perform binary addition
    wire [4:0] sum_temp = A + B + Cin;
    
    // Check if sum >9 or carry occurred (BCD overflow)
    wire overflow = (sum_temp[4]) || (sum_temp[3:0] > 4'd9);
    
    // Apply correction if needed
    assign Sum = overflow ? (sum_temp[3:0] + 4'd6) : sum_temp[3:0];
    assign Cout = overflow;

endmodule