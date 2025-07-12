module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total bit width
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    output wire overflow
);

    // Internal signals
    wire [N-1:0] subtraction_result = a - b;

    // Overflow detection (occurs when signs of a and b differ and result sign differs from a)
    assign overflow = (a[N-1] != b[N-1]) && (subtraction_result[N-1] != a[N-1]);

    // Result handling
    always @(*) begin
        if (subtraction_result == {N{1'b0}}) begin
            c = {1'b0, {N-1{1'b0}}};  // Explicit positive zero
        end else begin
            c = subtraction_result;    // Direct subtraction result
        end
    end

endmodule