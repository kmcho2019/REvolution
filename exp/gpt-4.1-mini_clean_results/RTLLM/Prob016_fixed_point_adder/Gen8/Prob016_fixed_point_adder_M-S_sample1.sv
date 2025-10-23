module fixed_point_adder #(
    parameter integer Q = 8,       // Number of fractional bits (precision)
    parameter integer N = 16       // Total number of bits including sign
)(
    input  wire [N-1:0] a,         // Fixed-point input operand A (two's complement)
    input  wire [N-1:0] b,         // Fixed-point input operand B (two's complement)
    output reg  [N-1:0] c          // Fixed-point addition result (two's complement)
);

    reg signed [N:0] res;           // N+1 bit signed register to hold intermediate sum with overflow bit

    always @(*) begin
        // Perform signed addition on extended width to detect overflow
        res = $signed({a[N-1], a}) + $signed({b[N-1], b});

        // Truncate to N bits as result
        c = res[N-1:0];
    end

endmodule