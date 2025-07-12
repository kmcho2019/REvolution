module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal signals with operand isolation during reset
    wire signed [31:0] a_eff = rst ? 32'b0 : a;
    wire signed [31:0] b_eff = rst ? 32'b0 : b;
    
    // Internal registers and wires
    reg signed [31:0] acc_reg;
    wire signed [63:0] product;
    wire signed [31:0] next_acc;

    // Continuous assignment for multiplication (64-bit product)
    assign product = a_eff * b_eff;

    // Next accumulation value (32-bit truncated)
    assign next_acc = acc_reg + product[31:0];

    // Output assignment
    assign c = acc_reg;

    // Sequential accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 32'd0;
        end else begin
            acc_reg <= next_acc;
        end
    end

endmodule