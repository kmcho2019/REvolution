module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

    // Internal signals
    reg [31:0] input_a, input_b;
    reg [8:0] exponent_a, exponent_b;
    reg [23:0] mantissa_a, mantissa_b;
    reg sign_a, sign_b;
    reg [8:0] result_exponent;
    reg [23:0] result_mantissa;
    reg round_bit, guard_bit, sticky;
    reg [31:0] result;

    // Pipeline stages
    always @(*) begin
        // Input Stage
        input_a <= a;
        input_b <= b;
        exponent_a <= input_a[30:23];
        exponent_b <= input_b[30:23];
        mantissa_a <= input_a[22:0];
        mantissa_b <= input_b[22:0];
        sign_a <= input_a[31];
        sign_b <= input_b[31];

        // Exponent Stage
        result_exponent <= exponent_a + exponent_b - 9'b10000000;

        // Mantissa Stage
        {round_bit, guard_bit, sticky, result_mantissa} <= {1'b1, mantissa_a} * {1'b1, mantissa_b};

        // Rounding Stage
        if (guard_bit || round_bit || sticky) begin
            result_mantissa <= result_mantissa + 1;
        end

        // Output Stage
        result <= {sign_a ^ sign_b, result_exponent, result_mantissa};
    end

    // Pipeline registers
    reg [31:0] pipe_input_a, pipe_input_b;
    reg [8:0] pipe_exponent_a, pipe_exponent_b;
    reg [23:0] pipe_mantissa_a, pipe_mantissa_b;
    reg pipe_sign_a, pipe_sign_b;
    reg [8:0] pipe_result_exponent;
    reg [23:0] pipe_result_mantissa;
    reg pipe_round_bit, pipe_guard_bit, pipe_sticky;
    reg [31:0] pipe_result;

    always @(posedge clk) begin
        if (rst) begin
            // Reset pipeline registers
            pipe_input_a <= 0;
            pipe_input_b <= 0;
            pipe_exponent_a <= 0;
            pipe_exponent_b <= 0;
            pipe_mantissa_a <= 0;
            pipe_mantissa_b <= 0;
            pipe_sign_a <= 0;
            pipe_sign_b <= 0;
            pipe_result_exponent <= 0;
            pipe_result_mantissa <= 0;
            pipe_round_bit <= 0;
            pipe_guard_bit <= 0;
            pipe_sticky <= 0;
            pipe_result <= 0;
        end else begin
            // Pipeline stage 1: Input
            pipe_input_a <= input_a;
            pipe_input_b <= input_b;
            pipe_exponent_a <= exponent_a;
            pipe_exponent_b <= exponent_b;
            pipe_mantissa_a <= mantissa_a;
            pipe_mantissa_b <= mantissa_b;
            pipe_sign_a <= sign_a;
            pipe_sign_b <= sign_b;

            // Pipeline stage 2: Exponent
            pipe_result_exponent <= result_exponent;

            // Pipeline stage 3: Mantissa
            pipe_result_mantissa <= result_mantissa;

            // Pipeline stage 4: Rounding
            pipe_round_bit <= round_bit;
            pipe_guard_bit <= guard_bit;
            pipe_sticky <= sticky;

            // Pipeline stage 5: Output
            pipe_result <= result;
        end
    end

    assign z = pipe_result;

endmodule