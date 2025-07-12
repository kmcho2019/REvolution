module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] Sum;
    reg Cout;

    always @(*) begin
        // Calculate the binary sum of A, B, and Cin
        reg [4:0] bin_sum = A + B + Cin;

        // Apply BCD correction if the sum exceeds 9
        if (bin_sum > 9) begin
            Sum = bin_sum[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            Sum = bin_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule