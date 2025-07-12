module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute sum with carry ripple
    wire [4:0] sum_temp = A + B + Cin;
    
    // Overflow occurs if sum >9 or carry out from MSB
    wire overflow = (sum_temp[3:0] > 4'd9) | sum_temp[4];
    
    // Select corrected or uncorrected sum
    assign Sum = overflow ? (sum_temp[3:0] + 4'd6) : sum_temp[3:0];
    assign Cout = overflow;

endmodule