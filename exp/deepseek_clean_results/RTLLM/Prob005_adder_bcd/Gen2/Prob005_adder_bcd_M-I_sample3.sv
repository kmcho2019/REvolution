module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    // Binary addition of A + B + Cin
    wire [4:0] raw_sum = A + B + Cin;

    // Efficient check for sum >9: raw_sum[4] OR (raw_sum[3] AND (raw_sum[2] OR raw_sum[1]))
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Apply BCD correction if needed
    always @(*) begin
        {Cout, Sum} = correction_needed ? 
                      {1'b1, raw_sum[3:0] + 4'd6} :  // Correction case
                      {1'b0, raw_sum[3:0]};          // Normal case
    end

endmodule