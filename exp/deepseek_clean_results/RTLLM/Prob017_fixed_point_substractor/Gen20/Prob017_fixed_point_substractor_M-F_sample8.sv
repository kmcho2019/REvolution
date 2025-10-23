module fixed_point_subtractor #(
    parameter Q = 16,  // Fractional bits
    parameter N = 32   // Total bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    // Internal signals
    wire [N-1:0] subtraction_result;
    wire result_sign;
    wire is_zero;

    // Main subtraction operation
    assign subtraction_result = a - b;

    // Sign determination (MSB of result)
    assign result_sign = subtraction_result[N-1];

    // Zero detection (compare with 0)
    assign is_zero = (subtraction_result == {N{1'b0}});

    // Output assignment with zero handling
    always @(*) begin
        if (is_zero) begin
            c = {N{1'b0}};  // Force positive zero
        end else begin
            c = subtraction_result;
        end
    end

endmodule