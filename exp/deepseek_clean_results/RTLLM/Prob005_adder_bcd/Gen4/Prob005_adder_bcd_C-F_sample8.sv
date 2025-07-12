module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] binary_sum;
    wire correction_needed;

    // Perform binary addition of A + B + Cin
    assign binary_sum = A + B + Cin;

    // Check if correction is needed (sum > 9)
    assign correction_needed = (binary_sum > 4'b1001);

    // Apply correction and generate carry
    always @(*) begin
        if (correction_needed) begin
            Sum = binary_sum + 4'b0110;  // Add correction factor 6
            Cout = 1'b1;                 // Set carry out
        end
        else begin
            Sum = binary_sum;            // No correction needed
            Cout = 1'b0;                 // No carry out
        end
    end

endmodule