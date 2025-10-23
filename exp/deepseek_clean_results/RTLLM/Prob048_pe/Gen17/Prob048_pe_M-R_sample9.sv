module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Full precision multiplication
    wire signed [63:0] product = a * b;

    // Accumulation register
    reg signed [31:0] acc_reg;

    // Continuous output assignment
    assign c = acc_reg;

    // Accumulation logic
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 32'sd0;
        end else begin
            acc_reg <= acc_reg + product[31:0];
        end
    end

endmodule