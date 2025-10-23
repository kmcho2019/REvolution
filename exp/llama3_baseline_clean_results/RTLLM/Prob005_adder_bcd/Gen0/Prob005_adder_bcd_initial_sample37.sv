module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal signal to hold the binary sum of A, B, and Cin
    wire [4:0] bin_sum;

    // Perform binary addition of A, B, and Cin
    assign bin_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Internal signal to hold the corrected BCD sum
    reg [3:0] corrected_sum;

    // Internal signal to hold the carry-out
    reg Cout_int;

    // Check if the binary sum exceeds 9 (binary 1001)
    always @(*)
    begin
        if (bin_sum > 4'd9)
        begin
            // Apply BCD correction and generate carry-out
            corrected_sum = bin_sum[3:0] + 4'd6;
            Cout_int = 1'b1;
        end
        else
        begin
            // No correction needed, just assign the binary sum
            corrected_sum = bin_sum[3:0];
            Cout_int = bin_sum[4];
        end
    end

    // Assign the corrected sum and carry-out to the output ports
    assign Sum = corrected_sum;
    assign Cout = Cout_int;

endmodule