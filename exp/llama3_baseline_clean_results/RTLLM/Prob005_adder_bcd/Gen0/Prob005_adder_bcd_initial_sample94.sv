module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] binary_sum;
    reg [3:0] temp_sum;
    reg Cout_reg;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // If the sum exceeds 9, add 6 to correct it and generate a carry-out
    always @(binary_sum) begin
        if (binary_sum > 9) begin
            temp_sum = binary_sum[3:0] + 4'd6;
            Cout_reg = 1'b1;
        end else begin
            temp_sum = binary_sum[3:0];
            Cout_reg = 1'b0;
        end
    end

    // Assign outputs
    assign Sum = temp_sum;
    assign Cout = Cout_reg;

endmodule