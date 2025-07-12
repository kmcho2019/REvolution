module sub_64bit (
    input clk,
    input enable,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] result,
    output reg overflow
);

    // Pipeline stage 1: Subtraction
    wire [64:0] full_result;
    assign full_result = {1'b0, A} - {1'b0, B};
    
    // Pipeline registers
    reg [63:0] stage1_result;
    reg stage1_carry;
    
    always @(posedge clk) if (enable) begin
        stage1_result <= full_result[63:0];
        stage1_carry <= full_result[64];
    end

    // Pipeline stage 2: Overflow detection
    always @(posedge clk) if (enable) begin
        result <= stage1_result;
        // Overflow occurs when carry out doesn't match sign bits
        overflow <= (A[63] ^ B[63]) && (stage1_carry ^ stage1_result[63]);
    end

endmodule