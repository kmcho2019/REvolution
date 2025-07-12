module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] temp_sum;
    wire correction_needed;

    // Perform binary addition including carry-in
    assign temp_sum = A + B + Cin;

    // Check if correction is needed (sum > 9 or carry generated)
    assign correction_needed = (temp_sum > 9) | (temp_sum[4]);

    // Apply correction if needed
    always @(*) begin
        if (correction_needed) begin
            Sum = temp_sum[3:0] + 6;
            Cout = 1'b1;
        end
        else begin
            Sum = temp_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule