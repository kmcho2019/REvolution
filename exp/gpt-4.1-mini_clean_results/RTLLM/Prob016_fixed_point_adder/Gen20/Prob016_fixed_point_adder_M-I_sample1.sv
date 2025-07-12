module fixed_point_adder #(
    parameter integer Q = 8,    // Number of fractional bits
    parameter integer N = 16    // Total width including sign bit
)(
    input  wire signed [N-1:0] a,      // Fixed-point input operand A (two's complement)
    input  wire signed [N-1:0] b,      // Fixed-point input operand B (two's complement)
    output reg  signed [N-1:0] c       // Fixed-point output result (two's complement)
);

    // Extended width sum for overflow detection
    wire signed [N:0] sum_ext;
    assign sum_ext = a + b;

    // Maximum and minimum representable fixed-point values
    // For signed N-bit number, max = 2^(N-1)-1, min = -2^(N-1)
    localparam signed [N-1:0] MAX_VAL = {(1'b0), {(N-1){1'b1}}};          // 0 followed by all ones (max positive)
    localparam signed [N-1:0] MIN_VAL = {1'b1, {(N-1){1'b0}}};            // 1 followed by all zeros (most negative)

    // Function to saturate sum to [MIN_VAL, MAX_VAL]
    function signed [N-1:0] saturate;
        input signed [N:0] value;
        begin
            // Overflow occurs if sum_ext[N] != sum_ext[N-1]
            // But we use the sign of inputs and sum for more precise detection
            // Alternatively, check sum_ext out of signed range
            if (value > MAX_VAL)
                saturate = MAX_VAL;
            else if (value < MIN_VAL)
                saturate = MIN_VAL;
            else
                saturate = value[N-1:0];
        end
    endfunction

    always @(*) begin
        c = saturate(sum_ext);
    end

endmodule