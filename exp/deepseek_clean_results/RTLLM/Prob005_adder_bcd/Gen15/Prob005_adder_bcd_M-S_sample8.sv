module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute initial sum including carry
    wire [4:0] sum_raw = A + B + Cin;
    
    // Detect if sum exceeds 9 (needs correction)
    wire overflow = (sum_raw[3:0] > 4'd9) || sum_raw[4];
    
    // Apply correction (add 6 if overflow) and get final sum
    assign Sum = overflow ? (sum_raw[3:0] + 4'd6) : sum_raw[3:0];
    
    // Carry out is simply the overflow signal
    assign Cout = overflow;

endmodule