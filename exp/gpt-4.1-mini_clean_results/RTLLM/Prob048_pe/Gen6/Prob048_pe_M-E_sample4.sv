module pe (
    input               clk,
    input               rst,
    input       [31:0]  a,
    input       [31:0]  b,
    output reg  [31:0]  c
);

    reg [31:0] acc_low;    // Low 32 bits of accumulator
    reg [31:0] acc_high;   // High 32 bits of accumulator (carry part)

    wire [63:0] product;
    wire [31:0] prod_low;
    wire [31:0] prod_high;

    wire [31:0] sum_low;
    wire        carry_low;

    assign product = a * b;
    assign prod_low = product[31:0];
    assign prod_high = product[63:32];

    // Add product low to acc_low with carry detection
    assign {carry_low, sum_low} = acc_low + prod_low;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_low <= 32'd0;
            acc_high <= 32'd0;
            c <= 32'd0;
        end else begin
            acc_low <= sum_low;
            // Add product high plus carry from low addition
            acc_high <= acc_high + prod_high + carry_low;
            c <= sum_low;  // output low 32 bits of accumulator
        end
    end

endmodule