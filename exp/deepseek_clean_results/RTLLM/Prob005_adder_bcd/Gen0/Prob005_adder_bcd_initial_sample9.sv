module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] binary_sum;
    wire correction_needed;

    // Step 1: Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Step 2: Determine if correction is needed (sum > 9 or carry generated)
    assign correction_needed = (binary_sum > 9) | (binary_sum[4] == 1'b1);

    // Step 3 & 4: Apply correction and generate outputs
    always @(*) begin
        if (correction_needed) begin
            Sum = binary_sum[3:0] + 4'd6;  // Add correction
            Cout = 1'b1;                    // Set carry out
        end
        else begin
            Sum = binary_sum[3:0];          // No correction needed
            Cout = 1'b0;                    // No carry out
        end
    end

endmodule