module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // Two 32-bit registers to store lower and upper parts of the accumulator
    reg [31:0] acc_low;
    reg [31:0] acc_high;

    // 64-bit product of inputs, split into high and low parts
    wire [63:0] product = a * b;
    wire [31:0] prod_low = product[31:0];
    wire [31:0] prod_high = product[63:32];

    // Addition with carry between lower and upper accumulators
    wire [31:0] new_low;
    wire [31:0] new_high;
    wire carry_out;

    // Add product low part and acc_low, generate carry out
    assign {carry_out, new_low} = acc_low + prod_low;
    // Add product high part, acc_high and carry from lower addition
    assign new_high = acc_high + prod_high + carry_out;

    // Asynchronous reset and synchronous accumulation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_low  <= 32'b0;
            acc_high <= 32'b0;
        end else begin
            acc_low  <= new_low;
            acc_high <= new_high;
        end
    end

    // Output the lower 32 bits of the accumulated sum
    assign c = acc_low;

endmodule