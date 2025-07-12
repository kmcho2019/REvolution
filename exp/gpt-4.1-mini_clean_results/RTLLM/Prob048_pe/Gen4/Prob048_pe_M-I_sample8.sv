module pe (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        enable,
    output wire [31:0] c
);

    // 64-bit product registered for pipelining
    reg [63:0] product_reg;
    wire [63:0] product;

    assign product = a * b;

    // 64-bit accumulator register
    reg [63:0] acc_reg;

    // Pipeline the product to reduce combinational path
    always @(posedge clk) begin
        if (rst) begin
            product_reg <= 64'b0;
            acc_reg     <= 64'b0;
        end else begin
            product_reg <= product;
            if (enable) begin
                acc_reg <= acc_reg + product_reg;
            end
        end
    end

    // Output lower 32 bits of accumulator as required
    assign c = acc_reg[31:0];

endmodule