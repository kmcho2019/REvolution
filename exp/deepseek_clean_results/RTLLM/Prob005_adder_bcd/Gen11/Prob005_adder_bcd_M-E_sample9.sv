module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Pre-corrected B input (add 6 when Cin=1)
    wire [3:0] B_corrected = B + (Cin ? 4'd6 : 4'd0);
    
    // Normal addition path
    wire [4:0] sum_normal = A + B + Cin;
    wire normal_carry = sum_normal[4];
    wire normal_overflow = (sum_normal[3:0] > 4'd9);
    
    // Pre-corrected addition path
    wire [4:0] sum_precorrected = A + B_corrected;
    wire precorrected_carry = sum_precorrected[4];
    
    // Result selection
    wire need_correction = normal_carry | normal_overflow;
    assign Sum = need_correction ? sum_precorrected[3:0] : sum_normal[3:0];
    assign Cout = need_correction ? precorrected_carry : normal_carry;

endmodule