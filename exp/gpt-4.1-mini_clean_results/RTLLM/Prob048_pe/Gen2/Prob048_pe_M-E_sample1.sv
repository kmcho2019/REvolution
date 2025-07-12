module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    // 64-bit internal accumulator register
    reg [63:0] acc;

    // 64-bit product wire
    wire [63:0] product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // Output lower 32 bits of accumulator as result
    assign c = acc[31:0];

endmodule