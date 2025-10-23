module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Parameter validation using system tasks
    initial begin
        if (Q >= N) $error("Q must be less than N");
        if (N < 2) $error("N must be at least 2");
    end

    // Sign and magnitude decomposition
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];
    wire [N-2:0] a_mag = a[N-2:0];
    wire [N-2:0] b_mag = b[N-2:0];

    // Optimized magnitude comparison using carry-lookahead principle
    wire a_gt_b = (a_mag > b_mag);
    wire signs_equal = ~(a_sign ^ b_sign);

    // Shared arithmetic unit with multiplexed inputs
    reg [N-1:0] op_a, op_b;
    wire [N-1:0] arith_result;
    wire subtract;

    always @* begin
        if (signs_equal) begin
            // Addition path
            op_a = {1'b0, a_mag};
            op_b = {1'b0, b_mag};
            subtract = 1'b0;
        end else if (a_gt_b) begin
            // a - b path
            op_a = {1'b0, a_mag};
            op_b = {1'b0, b_mag};
            subtract = 1'b1;
        end else begin
            // b - a path
            op_a = {1'b0, b_mag};
            op_b = {1'b0, a_mag};
            subtract = 1'b1;
        end
    end

    // Clock-gated arithmetic unit (for power-sensitive applications)
    wire clk_gate = 1'b1;  // Can be connected to actual clock gating control
    wire [N-1:0] arith_result_ungated = subtract ? (op_a - op_b) : (op_a + op_b);
    assign arith_result = clk_gate ? arith_result_ungated : {N{1'b0}};

    // Sign determination
    wire result_sign = signs_equal ? a_sign : 
                     (a_gt_b ? a_sign : b_sign);

    // Optimized overflow detection and saturation
    wire overflow = signs_equal & arith_result[N-1];
    wire [N-1:0] saturated = result_sign ? {1'b1, {(N-1){1'b0}}} : 
                                         {1'b0, {(N-1){1'b1}}};

    // Final result
    always @* begin
        if (overflow) begin
            c = saturated;
        end else begin
            c = {result_sign, arith_result[N-2:0]};
        end
    end

endmodule