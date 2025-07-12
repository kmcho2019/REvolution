module fixed_point_subtractor #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a,  // First input operand
    input   [N-1:0] b,  // Second input operand
    output  [N-1:0] c   // Result of subtraction
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Determine the signs of the inputs
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin // Both positive
        if (a >= b) begin // a is greater than or equal to b
            res = a - b;
        end else begin // a is less than b
            res = {1'b1, {(N-1){1'b0}}} + (~b + 1'b1) - a;
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin // Both negative
        if (a <= b) begin // a is less than or equal to b
            res = a - b;
        end else begin // a is greater than b
            res = {1'b1, {(N-1){1'b0}}} + (~b + 1'b1) - a;
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
        res = a + (~b + 1'b1); // Add the absolute values
    end else begin // a is negative, b is positive
        res = (~a + 1'b1) + b; // Add the absolute values
    end

    // Handle the zero result case
    if (res == {N{1'b0}}) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule