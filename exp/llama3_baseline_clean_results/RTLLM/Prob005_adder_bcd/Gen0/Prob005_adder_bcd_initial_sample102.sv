module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Temporary sum variable to hold the result of binary addition
wire [4:0] temp_sum;

// Perform binary addition of A, B, and Cin
assign temp_sum = A + B + Cin;

// If the sum exceeds 9, add a correction of 6
always @(*) begin
    if (temp_sum > 9) begin
        Sum = temp_sum + 6;
        Cout = 1;
    end else begin
        Sum = temp_sum[3:0];
        Cout = temp_sum[4];
    end
end

endmodule