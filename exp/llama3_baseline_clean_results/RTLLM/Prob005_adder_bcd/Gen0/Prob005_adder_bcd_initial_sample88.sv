module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction if necessary
    reg [3:0] sum;
    reg cout;
    always @(*) begin
        if (binary_sum > 9) begin
            sum = binary_sum[3:0] + 4'b0110; // Apply correction by adding 6
            cout = 1'b1; // Set carry-out
        end else begin
            sum = binary_sum[3:0]; // Directly assign the sum
            cout = binary_sum[4]; // The most significant bit represents the carry-out
        end
    end

    assign Sum = sum;
    assign Cout = cout;

endmodule