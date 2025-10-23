module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition of A, B, and Cin
reg [4:0] temp_sum;
always @(A or B or Cin) begin
    temp_sum = A + B + Cin;
end

// Generate the carry-out and correct the sum if it exceeds 9
always @(temp_sum) begin
    if (temp_sum > 9) begin
        Sum = temp_sum + 6;
        Cout = 1'b1;
    end else begin
        Sum = temp_sum[3:0];
        Cout = 1'b0;
    end
end

endmodule