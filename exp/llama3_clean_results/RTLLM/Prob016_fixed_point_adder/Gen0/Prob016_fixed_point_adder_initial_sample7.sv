module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the operation based on the MSBs of a and b
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = (a[N-1] == 1'b0) ? (a + b) : (-a + (-b));
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // a is positive, b is negative
            if (a >= -b) begin
                res = a + (-b);
            end else begin
                res = -b + a;
                res[N-1] = 1'b1; // Set MSB to 1 (negative)
            end
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // a is negative, b is positive
            if (b >= -a) begin
                res = b + (-a);
            end else begin
                res = -a + b;
                res[N-1] = 1'b1; // Set MSB to 1 (negative)
            end
        end
    end

    // Handle overflow
    if (res >= 2**N) begin
        res = 2**N - 1;
    end else if (res < -2**(N-1)) begin
        res = -2**(N-1);
    end

    c = res; // Assign the result to the output port
end

endmodule