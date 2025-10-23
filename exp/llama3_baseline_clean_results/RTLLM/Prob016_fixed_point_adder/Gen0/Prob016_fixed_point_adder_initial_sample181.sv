module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same signs, perform addition
        res = a + b;
    end else begin  // Different signs, perform subtraction
        if (a > b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Adjust result to match the sign of the operands
    if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        if (res < 0) begin
            c = {1'b1, res[N-2:0]};
        end else begin
            c = {1'b0, res[N-2:0]};
        end
    end else begin  // At least one positive operand
        c = res;
    end
    
    // Handle overflow
    if (c[N-1]!= res[N-1]) begin  // Sign change indicates overflow
        if (res > 0) begin
            c = {1'b1, {N-1{1'b1}}};
        end else begin
            c = {1'b0, {N-1{1'b0}}};
        end
    end
end

endmodule