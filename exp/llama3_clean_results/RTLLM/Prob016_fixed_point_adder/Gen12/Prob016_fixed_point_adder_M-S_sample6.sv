module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Check if the MSBs of a and b are the same
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
    
    // Handle overflow
    if (res[N]) begin
        // Saturate at max value for overflow
        c = {N{1'b1}};
    end else begin
        // Assign the result
        c = res;
    end
end

endmodule