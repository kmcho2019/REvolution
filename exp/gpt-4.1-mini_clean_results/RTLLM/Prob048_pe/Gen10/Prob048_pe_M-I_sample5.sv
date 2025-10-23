module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] product_reg;
    reg [32:0] acc_ext; // 33-bit to detect saturation

    wire [63:0] product = a * b;
    wire [32:0] sum_ext = acc_ext + product_reg[31:0];

    wire overflow = sum_ext[32];

    // Stage 1: Register multiplication result
    always @(posedge clk or posedge rst) begin
        if (rst)
            product_reg <= 64'd0;
        else
            product_reg <= product;
    end

    // Stage 2: Accumulate with saturation
    always @(posedge clk or posedge rst) begin
        if (rst)
            acc_ext <= 33'd0;
        else begin
            if (overflow)
                acc_ext <= 33'h1_0000_0000 - 1; // 0xFFFFFFFF max 32-bit saturated value
            else
                acc_ext <= sum_ext;
        end
    end

    assign c = acc_ext[31:0];

endmodule