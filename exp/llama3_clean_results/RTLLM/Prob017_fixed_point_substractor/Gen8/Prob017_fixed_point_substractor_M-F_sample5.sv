module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

// Perform subtraction based on the signs of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        c = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        c = a + (~b + 1);  // Add a and the two's complement of b
    end else begin  // a is negative, b is positive
        c = (~a + 1) + b;  // Add the two's complement of a and b
    end
    
    // Handle the zero result case directly
    if (c == 0) begin
        c = {1'b0, {N-1{1'b0}}};  // Set the sign bit and remaining bits to 0
    end
end

endmodule