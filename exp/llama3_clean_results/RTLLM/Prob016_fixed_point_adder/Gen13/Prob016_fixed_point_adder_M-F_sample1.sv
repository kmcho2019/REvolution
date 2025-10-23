module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Internal register to store the result
reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Add the absolute values of a and b
        res = a + b;
    end else begin
        // Determine the larger absolute value and perform subtraction
        if (a >= b) begin
            res = a - b;
        end else begin
            res = b - a;
        end
    end
    
    // Assign the result directly, relying on the inherent saturation of the N-bit register
    c = res;
end

endmodule