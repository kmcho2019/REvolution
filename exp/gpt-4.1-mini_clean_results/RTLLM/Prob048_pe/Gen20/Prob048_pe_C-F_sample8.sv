module pe (
    input           clk,
    input           rst,        // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    // Full 32x32 multiplication produces 64-bit product
    wire [63:0] product = a * b;

    // Extend c by 1 bit to detect overflow after addition
    wire [32:0] sum_ext = {1'b0, c} + product[31:0];

    // Overflow occurs if sum exceeds 32-bit max value (carry out bit is 1)
    wire overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            // Saturate on overflow; otherwise accumulate sum
            if (overflow)
                c <= 32'hFFFF_FFFF;
            else
                c <= sum_ext[31:0];
        end
    end

endmodule