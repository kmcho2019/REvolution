module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output reg overflow
);

    wire [62:0] A_LSB;
    wire [62:0] B_LSB;
    wire [62:0] result_LSB;
    reg [63:0] temp_result;

    assign A_LSB = A[62:0];
    assign B_LSB = B[62:0];

    // Calculate the result of the subtraction for the 63 least significant bits
    assign result_LSB = A_LSB - B_LSB;

    // Calculate the temporary result including the sign bit
    assign temp_result = {A[63], result_LSB};

    // Determine the overflow condition
    always @(*) begin
        if (A[63] == 1 && B[63] == 0 && temp_result[63] == 0) begin
            // Negative overflow
            overflow = 1;
        end else if (A[63] == 0 && B[63] == 1 && temp_result[63] == 1) begin
            // Positive overflow
            overflow = 1;
        end else begin
            // No overflow
            overflow = 0;
        end
    end

    // Assign the final result
    assign result = temp_result;

endmodule