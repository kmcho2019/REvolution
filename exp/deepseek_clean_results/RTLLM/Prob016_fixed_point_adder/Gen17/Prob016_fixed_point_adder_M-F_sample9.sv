module fixed_point_adder #(
    parameter Q = 8,  // Fractional bits
    parameter N = 16  // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    // Parameter validation using generate
    generate
        if (Q >= N) begin
            initial $error("Error: Q must be less than N");
        end
        if (N < 2) begin
            initial $error("Error: N must be at least 2");
        end
    endgenerate

    // Sign bits and comparison
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire signs_equal = ~(a_sign ^ b_sign);

    // Sign-extended operands
    wire [N:0] a_ext = {a_sign, a};
    wire [N:0] b_ext = {b_sign, b};

    // Conditional inversion for subtraction
    wire [N:0] b_operand = signs_equal ? b_ext : ~b_ext + 1'b1;

    // Full arithmetic operation
    wire [N:0] sum = a_ext + b_operand;

    // Overflow/underflow detection
    wire overflow = signs_equal & (sum[N] != sum[N-1]);
    wire underflow = ~signs_equal & (sum[N] != a_sign);

    // Result selection
    reg [N-1:0] result;
    always @(*) begin
        case ({overflow, underflow})
            2'b10: result = {a_sign, {(N-1){~a_sign}};  // Overflow saturation
            2'b01: result = {b_sign, {(N-1){~b_sign}};  // Underflow saturation
            default: result = sum[N-1:0];                // Normal result
        endcase
    end

    assign c = result;

endmodule