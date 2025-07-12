module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] raw_sum;
    wire need_correction;

    // Binary addition of A + B + Cin
    assign raw_sum = A + B + Cin;

    // Check if correction is needed (sum > 9 or carry occurred)
    assign need_correction = (raw_sum > 9) || (raw_sum[4] == 1'b1);

    // Apply BCD correction if needed
    always @(*) begin
        if (need_correction) begin
            Sum = raw_sum[3:0] + 6;  // Add 6 to correct to BCD
            Cout = 1'b1;              // Set carry out
        end
        else begin
            Sum = raw_sum[3:0];       // No correction needed
            Cout = 1'b0;             // No carry out
        end
    end

endmodule