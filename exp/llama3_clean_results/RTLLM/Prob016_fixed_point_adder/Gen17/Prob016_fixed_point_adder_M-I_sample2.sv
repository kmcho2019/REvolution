module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res; // Result register

always @(*) begin
    // Perform addition or subtraction based on signs
    if (a[N-1] == b[N-1]) begin
        // Same signs, add absolute values
        res = a + b;
    end else begin
        // Different signs, subtract absolute values
        if (a[N-1]) begin
            // a is negative, subtract b from a
            res = -a + b;
        end else begin
            // b is negative, subtract a from b
            res = a - b;
        end
    end
    
    // Handle overflow implicitly through two's complement
    if (res[N-1] != a[N-1] && res[N-1] != b[N-1]) begin
        // Overflow detected, saturate result
        if (res[N-1]) begin
            res = {N{1'b1}};
        end else begin
            res = {N{1'b0}};
        end
    end
end

assign c = res;

endmodule