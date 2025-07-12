module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition
    reg [4:0] sum_uncorrected;
    assign sum_uncorrected = A + B + Cin;

    // Check if the sum exceeds 9 and apply correction
    reg [4:0] sum_corrected;
    reg cout_temp;
    always @(sum_uncorrected) begin
        if (sum_uncorrected > 9) begin
            sum_corrected = sum_uncorrected + 6;
            cout_temp = 1;
        end else begin
            sum_corrected = sum_uncorrected;
            cout_temp = 0;
        end
    end

    // Assign the final sum and carry-out
    assign Sum = sum_corrected[3:0];
    assign Cout = cout_temp;

endmodule