module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input  [N-1:0] a,  // First N-bit fixed-point input operand
    input  [N-1:0] b,  // Second N-bit fixed-point input operand
    output [N-1:0] c   // N-bit output representing the result of the fixed-point subtraction
);

reg [N-1:0] res;  // N-bit register used to store the result of the subtraction operation

always @(*) begin
    // Determine the signs of the input operands
    reg sign_a = a[N-1];  // Sign bit of a
    reg sign_b = b[N-1];  // Sign bit of b

    // Same Sign Subtraction
    if (sign_a == sign_b) begin
        // Subtract the absolute values
        res = (sign_a)? ({1'b1, {N-1{1'b0}}} + ~a + 1) - ({1'b1, {N-1{1'b0}}} + ~b + 1) :
                              a - b;
    end
    // Different Sign Subtraction
    else begin
        // Add the absolute values
        if (a[N-1:0] > b[N-1:0]) begin
            res = (a[N-1])? ({1'b1, {N-1{1'b0}}} + ~a + 1) : a;
            res = res - (b[N-1])? ({1'b1, {N-1{1'b0}}} + ~b + 1) : b;
        end else begin
            res = (b[N-1])? ({1'b1, {N-1{1'b0}}} + ~b + 1) : b;
            res = res - (a[N-1])? ({1'b1, {N-1{1'b0}}} + ~a + 1) : a;
        end
    end

    // Handle Zero result case
    if (res == {N{1'b0}}) begin
        c = {1'b0, {N-1{1'b0}}};  // Set sign bit to 0
    end else begin
        c = res;  // Assign the result to the output
    end
end

endmodule