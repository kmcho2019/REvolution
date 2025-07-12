module freq_diveven #
(
    parameter integer NUM_DIV = 4  // Must be even and >= 2
)
(
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);

    // Compile-time assertion for even NUM_DIV >= 2
    // Verilog-2001 does not support direct compile-time assertions,
    // so we use a parameter that will cause an elaboration error if condition fails.
    // For SystemVerilog, use 'assert' if available.
    localparam VALID_DIV = (NUM_DIV >= 2) && ((NUM_DIV % 2) == 0) ? 1 : 0;
    // Force elaboration error for invalid NUM_DIV by creating an illegal width vector
    wire [VALID_DIV-1:0] check_valid_div = {VALID_DIV{1'b1}};

    // Constants
    localparam HALF_DIV = NUM_DIV >> 1;

    // 4-bit down-counter as requested
    reg [3:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= HALF_DIV - 1;
            clk_div <= 0;
        end else begin
            if (cnt == 0) begin
                cnt     <= HALF_DIV - 1;
                clk_div <= ~clk_div;
            end else begin
                cnt <= cnt - 1;
            end
        end
    end

endmodule