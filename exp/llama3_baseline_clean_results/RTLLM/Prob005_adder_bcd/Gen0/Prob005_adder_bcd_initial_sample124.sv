module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Internal wire for binary sum
wire [4:0] bin_sum;

// Perform binary addition of A, B, and Cin
assign bin_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

// Conditional statement to correct sum and generate carry
always @(*) begin
    if (bin_sum > 9) begin
        // Add 6 to correct sum to stay within BCD range
        Sum = bin_sum[3:0] + 4'b0110;
        // Generate carry-out
        Cout = 1'b1;
    end else begin
        Sum = bin_sum[3:0];
        Cout = bin_sum[4];
    end
end

endmodule