module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal wires for temporary results
    wire [3:0] temp_sum;
    reg [3:0] Sum;
    reg Cout;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction
    always @(temp_sum) begin
        if (temp_sum > 9) begin
            // Apply correction and generate carry-out
            Sum = temp_sum + 6;
            Cout = 1'b1;
        end else begin
            Sum = temp_sum;
            Cout = 1'b0;
        end
    end

endmodule