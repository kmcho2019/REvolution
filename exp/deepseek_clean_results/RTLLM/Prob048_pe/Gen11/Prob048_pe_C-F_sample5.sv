module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Internal signals with operand isolation during reset
    wire signed [31:0] a_eff = rst ? 32'b0 : a;
    wire signed [31:0] b_eff = rst ? 32'b0 : b;
    
    // 64-bit product to prevent intermediate overflow
    wire signed [63:0] product = a_eff * b_eff;

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'b0;  // Clear on reset
        end else begin
            // Accumulate with 32-bit truncation
            c <= c + product[31:0];
        end
    end

endmodule