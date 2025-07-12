module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Internal signals
    reg signed [31:0] acc_reg;
    wire signed [63:0] product;
    wire signed [31:0] next_acc;

    // Continuous assignment for multiplication
    assign product = a * b;

    // Next accumulation value (combinational)
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