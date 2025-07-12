module sub_64bit (
    input clk,
    input enable,
    input signed [63:0] A,
    input signed [63:0] B,
    output reg signed [63:0] result,
    output reg overflow
);

    reg signed [63:0] sub_result;
    reg a_sign, b_sign, res_sign;

    always @(posedge clk) begin
        if (enable) begin
            // Stage 1: Perform subtraction
            sub_result <= A - B;
            
            // Stage 1: Capture signs
            a_sign <= A[63];
            b_sign <= B[63];
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            // Stage 2: Register result and detect overflow
            result <= sub_result;
            res_sign <= sub_result[63];
            
            // Simplified overflow detection:
            // Overflow occurs when signs of A and B differ and result sign differs from A sign
            overflow <= (a_sign ^ b_sign) & (a_sign ^ res_sign);
        end
    end

endmodule