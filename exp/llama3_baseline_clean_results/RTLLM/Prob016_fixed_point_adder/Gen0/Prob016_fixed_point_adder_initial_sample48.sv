module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   signed [N-1:0] a,
    input   signed [N-1:0] b,
    output  signed [N-1:0] c
);

reg [N-1:0] res;  // Register to store the result

// Calculate the integer part size
localparam INTEGER_PART_SIZE = N - Q;

always @(*) begin
    // Determine the operation type (addition or subtraction)
    if (a[N-1] == b[N-1]) begin  // Same signs
        // Perform absolute value addition
        res = a + b;
    end else begin  // Different signs
        // Perform absolute value subtraction
        if (a[N-1] == 0) begin  // a is positive
            if (a >= -b) begin  // a is greater than or equal to -b
                res = a + (~b + 1);  // a - b
            end else begin
                res = (~a + 1) + b;  // b - a
            end
        end else begin  // a is negative
            if (a <= -b) begin  // a is less than or equal to -b
                res = a + (~b + 1);  // a - b
            end else begin
                res = (~a + 1) + b;  // b - a
            end
        end
    end

    // Handle overflow
    if (res >= (1 << (N-1))) begin
        res = (1 << (N-1)) - 1;
    end else if (res < -(1 << (N-1))) begin
        res = -(1 << (N-1));
    end

    // Assign the result to the output port
    c = res;
end

endmodule