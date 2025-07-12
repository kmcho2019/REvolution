module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Temporary sum including carry in
    wire [4:0] temp_sum = A + B + Cin;
    
    // Determine if correction is needed (sum > 9)
    wire needs_correction = (temp_sum[4] || (temp_sum[3] && (temp_sum[2] || temp_sum[1])));
    
    // Apply correction if needed
    assign Sum = needs_correction ? temp_sum[3:0] + 4'd6 : temp_sum[3:0];
    assign Cout = needs_correction;

endmodule