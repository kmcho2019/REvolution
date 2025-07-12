module fixed_point_subtractor #(
    parameter Q = 16,        // Number of fractional bits (0 < Q < N)
    parameter N = 32,         // Total bit width (N > 1)
    parameter SATURATE = 1,   // 1: enable saturation, 0: wrap-around
    parameter PIPELINE = 0    // 0: combinational, 1: registered output
) (
    input wire signed [N-1:0] a,    // First fixed-point operand (Q.N format)
    input wire signed [N-1:0] b,    // Second fixed-point operand
    input wire clk,                 // Clock (required if PIPELINE=1)
    output reg signed [N-1:0] c     // Subtraction result
);

    // Internal signals
    wire signed [N-1:0] sub_result;
    wire signed [N-1:0] saturated_result;
    wire overflow_positive, overflow_negative;

    // Parameter validation (synthesizable)
    generate
        if (Q <= 0 || Q >= N) begin
            initial $error("Invalid Q parameter: must be 0 < Q < N");
        end
    endgenerate

    // Core subtraction operation
    assign sub_result = a - b;

    // Overflow detection (only used if SATURATE=1)
    assign overflow_positive = (a[N-1] == b[N-1]) && (sub_result[N-1] != a[N-1]) && ~a[N-1];
    assign overflow_negative = (a[N-1] == b[N-1]) && (sub_result[N-1] != a[N-1]) && a[N-1];

    // Saturation logic
    assign saturated_result = (SATURATE && overflow_positive) ? {1'b0, {(N-1){1'b1}}} :
                             (SATURATE && overflow_negative) ? {1'b1, {(N-1){1'b0}}} :
                             sub_result;

    // Output handling
    generate
        if (PIPELINE) begin
            always @(posedge clk) begin
                c <= saturated_result;
            end
        end else begin
            always @(*) begin
                c = saturated_result;
            end
        end
    endgenerate

endmodule