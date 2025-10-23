module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Operand isolation during reset
    wire signed [31:0] a_eff = rst ? 32'b0 : a;
    wire signed [31:0] b_eff = rst ? 32'b0 : b;
    
    // Internal accumulation register
    reg signed [31:0] acc_reg;
    
    // Direct accumulation assignment
    wire signed [31:0] product = a_eff * b_eff;
    wire signed [31:0] next_acc = acc_reg + product;

    // Output assignment
    assign c = acc_reg;

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        acc_reg <= rst ? 32'd0 : next_acc;
    end

endmodule