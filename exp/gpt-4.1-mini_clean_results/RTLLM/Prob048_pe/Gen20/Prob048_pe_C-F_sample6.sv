module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    // 64-bit accumulator register to hold full accumulation result
    reg  [63:0] acc;
    wire [63:0] product;
    wire [64:0] sum_ext;    // one bit wider to detect overflow (carry-out)
    wire        overflow;

    // Full 32x32 multiplication, combinational
    assign product = a * b;

    // Add current product to accumulator with extended bit for overflow detection
    assign sum_ext = {1'b0, acc} + {1'b0, product};

    // Overflow occurs if carry-out bit of sum_ext is set, or acc saturated already
    assign overflow = sum_ext[64];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            if (overflow) begin
                acc <= 64'hFFFF_FFFF_FFFF_FFFF; // Saturate at max 64-bit unsigned
            end else begin
                acc <= sum_ext[63:0];
            end
        end
    end

    // Output lower 32 bits of the accumulator as final accumulated result
    assign c = acc[31:0];

endmodule