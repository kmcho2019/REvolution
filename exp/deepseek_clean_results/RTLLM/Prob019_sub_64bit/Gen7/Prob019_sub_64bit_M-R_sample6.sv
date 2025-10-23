module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

    // Internal signals
    wire signed [63:0] sub_result;
    wire ovf_condition;

    // Perform subtraction
    assign sub_result = A - B;

    // Overflow detection logic
    assign ovf_condition = (A[63] ^ B[63]) && (A[63] ^ sub_result[63]);

    // Update outputs in always block
    always @(*) begin
        result = sub_result;
        overflow = ovf_condition;
    end

endmodule