module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] pre_sum;
    wire [3:0] pre_corrected_sum;
    wire correction_predicted;

    // Predict if correction will be needed (A + B will be >= 10)
    // Cases where sum will be >= 10:
    // 1. A >= 8 and B >= 2
    // 2. A >= 5 and B >= 5
    // 3. Any combination where A + B >= 10
    assign correction_predicted = 
        ((A[3] & (B[3] | B[2] | B[1])) |  // A >=8 and B >=2
         (B[3] & (A[3] | A[2] | A[1])) |   // B >=8 and A >=2
        ((A[3] | (A[2] & A[1])) & (B[3] | (B[2] & B[1])) |  // Both >=5
        ((A + B) >= 10);  // Fallback exact check

    // Calculate both possible sums in parallel
    assign pre_sum = A + B + Cin;
    assign pre_corrected_sum = A + B + Cin + 6;

    // Select appropriate result and set carry
    always @(*) begin
        if (correction_predicted) begin
            Sum = pre_corrected_sum[3:0];
            Cout = pre_corrected_sum[4] | (pre_sum > 9);
        end
        else begin
            Sum = pre_sum[3:0];
            Cout = pre_sum[4];
        end
    end

endmodule