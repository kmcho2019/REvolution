module fixed_point_adder #(
    parameter integer Q = 8,           // Number of fractional bits
    parameter integer N = 16           // Total bits (including sign)
)(
    input  wire [N-1:0] a,             // Fixed-point input operand a
    input  wire [N-1:0] b,             // Fixed-point input operand b
    output reg  [N-1:0] c              // Fixed-point output result c
);

    // Extended width for addition to detect overflow
    localparam integer EX_WIDTH = N + 1;

    // Perform addition in signed extended width
    wire signed [EX_WIDTH-1:0] a_ext = {{1{a[N-1]}}, a};
    wire signed [EX_WIDTH-1:0] b_ext = {{1{b[N-1]}}, b};
    wire signed [EX_WIDTH-1:0] sum_ext = a_ext + b_ext;

    // Maximum and minimum representable values in N-bit signed fixed-point
    localparam signed [N-1:0] MAX_VAL = {1'b0, {(N-1){1'b1}}};       // 0x7FFF... for N bits
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};       // 0x8000... for N bits

    // Overflow detection:
    // If sum_ext[N] != sum_ext[N-1], overflow occurred
    wire overflow = (sum_ext[EX_WIDTH-1] != sum_ext[EX_WIDTH-2]);

    // Saturation logic: clamp to max or min fixed-point value
    wire signed [N-1:0] saturated_result = (sum_ext[EX_WIDTH-1] == 1'b0) ? MAX_VAL : MIN_VAL;

    always @(*) begin
        if (overflow) begin
            c = saturated_result;
        end else begin
            c = sum_ext[N-1:0];
        end
    end

endmodule