module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Internal register to store the result
reg signed [N-1:0] res;

// Perform addition or subtraction based on the signs of 'a' and 'b'
always @(*) begin
    if (a[N-1] == b[N-1]) begin
        // Addition: Add the absolute values and set the MSB accordingly
        res = (a[N-1] == 1'b0) ? (a + b) : -(~a + 1 + ~b + 1);
    end else begin
        // Subtraction: Compare absolute values and perform subtraction
        if (a[N-1] == 1'b0) begin
            if (a >= -b) begin
                res = a + b;
            end else begin
                res = b + a;
            end
        end else begin
            if (-a >= b) begin
                res = -a - b;
            end else begin
                res = -b - a;
            end
        end
    end
    // Assign the result to the output 'c'
    c = res;
end

endmodule