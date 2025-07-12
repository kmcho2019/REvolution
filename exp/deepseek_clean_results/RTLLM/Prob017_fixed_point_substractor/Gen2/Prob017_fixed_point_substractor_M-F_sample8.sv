module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,  // First operand
    input wire [N-1:0] b,  // Second operand
    output reg [N-1:0] c   // Result
);

    // Internal signed representation for arithmetic
    wire signed [N-1:0] a_signed = a;
    wire signed [N-1:0] b_signed = b;
    wire signed [N-1:0] result;

    assign result = a_signed - b_signed;

    always @(*) begin
        c = result;
        
        // Explicit zero handling - clear sign bit if magnitude is zero
        if (result[N-2:0] == {(N-1){1'b0}}) begin
            c[N-1] = 1'b0;
        end
    end

endmodule