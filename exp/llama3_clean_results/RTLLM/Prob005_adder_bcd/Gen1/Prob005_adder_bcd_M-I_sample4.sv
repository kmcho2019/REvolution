module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    always @(A, B, Cin) begin
        binary_sum = A + B + Cin;
        if (binary_sum > 4'd9) begin
            Sum = binary_sum[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule