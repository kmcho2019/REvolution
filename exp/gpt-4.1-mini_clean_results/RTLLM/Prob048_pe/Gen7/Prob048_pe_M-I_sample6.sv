module pe (
    input wire clk,
    input wire rst,              // synchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // Pipeline registers
    reg [63:0] mult_reg;
    reg [63:0] acc_reg;

    // Stage 1: multiply and register
    always @(posedge clk) begin
        if (rst) begin
            mult_reg <= 64'd0;
        end else begin
            mult_reg <= a * b;  // unsigned multiply
        end
    end

    // Stage 2: accumulate and register
    always @(posedge clk) begin
        if (rst) begin
            acc_reg <= 64'd0;
        end else begin
            acc_reg <= acc_reg + mult_reg;
        end
    end

    assign c = acc_reg[31:0];

endmodule