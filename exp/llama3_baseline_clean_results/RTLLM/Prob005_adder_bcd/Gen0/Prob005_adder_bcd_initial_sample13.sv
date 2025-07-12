module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

// Perform binary addition of A, B, and Cin
wire [4:0] binary_sum = A + B + Cin;

// Check if the sum exceeds 9 (1001 in binary), apply correction if necessary
reg [3:0] corrected_sum;
reg       corrected_cout;

always @(binary_sum) begin
    if (binary_sum > 4'd9) begin
        // Apply correction by adding 6 (0110 in binary)
        corrected_sum = binary_sum[3:0] + 4'd6;
        // Generate carry-out if the result exceeds 9
        corrected_cout = 1'b1;
    end else begin
        corrected_sum = binary_sum[3:0];
        corrected_cout = binary_sum[4];
    end
end

// Assign the corrected sum and carry-out to the output ports
assign Sum = corrected_sum;
assign Cout = corrected_cout;

endmodule