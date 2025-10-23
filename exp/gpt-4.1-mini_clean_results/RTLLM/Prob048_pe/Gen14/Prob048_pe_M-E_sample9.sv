module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous active-high reset
    input  wire [31:0] a,
    input  wire [31:0] b,
    output wire [31:0] c
);

    // Split 64-bit accumulator into two 32-bit registers
    reg [31:0] acc_lo;
    reg [31:0] acc_hi;

    // 64-bit product split into lower and upper 32-bit
    wire [31:0] prod_lo;
    wire [31:0] prod_hi;

    wire [32:0] sum_lo;   // 33-bit to catch carry out from lower half addition
    wire [32:0] sum_hi;   // 33-bit to add upper half plus carry-in

    // Multiply inputs: 64-bit product
    wire [63:0] product;
    assign product = a * b;

    assign prod_lo = product[31:0];
    assign prod_hi = product[63:32];

    // Add lower half with product lower half
    assign sum_lo = {1'b0, acc_lo} + {1'b0, prod_lo};

    // Add upper half with product upper half and carry from lower half
    assign sum_hi = {1'b0, acc_hi} + {1'b0, prod_hi} + sum_lo[32];

    // Sequential logic: update accumulator registers with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            acc_lo <= 32'd0;
            acc_hi <= 32'd0;
        end else begin
            acc_lo <= sum_lo[31:0];
            acc_hi <= sum_hi[31:0];
        end
    end

    // Output lower 32 bits of accumulator
    assign c = acc_lo;

endmodule