module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Predictive correction detection
    wire [3:0] sum_lower = A + B + Cin;
    wire [3:0] sum_upper = A + B + Cin + 4'd6;
    
    // Prediction logic (simpler than full comparison)
    wire will_overflow = (A > 4'd9 - B - Cin) | 
                        ((A == 4'd9 - B - Cin) & Cin);
    
    // Select correct sum and carry
    assign Sum = will_overflow ? sum_upper[3:0] : sum_lower[3:0];
    assign Cout = will_overflow;

endmodule