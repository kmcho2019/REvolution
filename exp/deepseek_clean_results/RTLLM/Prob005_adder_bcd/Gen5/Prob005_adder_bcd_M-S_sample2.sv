module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] raw_sum;
    wire carry_out;
    
    // 4-bit adder with carry
    assign {carry_out, raw_sum} = A + B + Cin;
    
    // Correction needed if sum >9 or carry occurred
    wire needs_correction = carry_out || (raw_sum > 4'd9);
    
    // Apply correction (add 6 if needed) and get final sum
    assign Sum = needs_correction ? raw_sum + 4'd6 : raw_sum;
    assign Cout = needs_correction;

endmodule