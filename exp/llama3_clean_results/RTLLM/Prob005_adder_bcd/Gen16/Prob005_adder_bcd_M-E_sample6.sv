module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire [4:0] bin_sum;
    wire [3:0] corrected_sum;
    
    // Perform binary addition
    assign bin_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};
    
    // Apply BCD correction
    assign corrected_sum = (bin_sum > 4'd9)? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];
    
    // Assign output signals
    assign Sum = corrected_sum;
    assign Cout = (bin_sum > 4'd9)? 1'b1 : 1'b0;
endmodule