module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,  // First N-bit fixed-point input operand
    input   [N-1:0] b,  // Second N-bit fixed-point input operand
    output  [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

    reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

    always @(a, b) begin
        if (a[N-1] == b[N-1]) begin  // Same signs, add absolute values
            res = (a[N-1] == 1'b0) ? (a + b) : (-a + (-b));  // Add or subtract based on sign
            c = res;
        end else begin  // Different signs, subtract absolute values
            if (($signed(a) > $signed(b))) begin
                res = a - b;
            end else begin
                res = b - a;
            end
            c = res;
        end
    end

endmodule