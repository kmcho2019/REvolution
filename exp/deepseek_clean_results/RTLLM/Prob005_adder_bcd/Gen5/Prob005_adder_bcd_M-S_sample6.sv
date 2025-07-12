module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // First do regular binary addition
    wire [4:0] sum_temp = A + B + Cin;
    
    // Check if sum >9 (need correction) or carry occurred
    wire overflow = (sum_temp[4]) || (sum_temp[3:0] > 4'd9);
    
    // Apply correction if needed (add 6)
    wire [4:0] sum_corrected = overflow ? sum_temp + 4'd6 : sum_temp;
    
    // Output assignments
    assign Sum = sum_corrected[3:0];
    assign Cout = sum_corrected[4];

endmodule