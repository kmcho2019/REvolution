module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
        // Ensure the MSB of the result matches the MSBs of a and b
        if (a[N-1]) begin
            // If a and b are negative, ensure the result is also negative
            if (res[N-1] == 0) begin
                res = {1'b1, {N-1{1'b1}}};
            end
        end else begin
            // If a and b are positive, ensure the result is also positive
            res[N-1] = 0;
        end
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1'b0) begin
            // a is positive, b is negative
            if (a >= ~b + 1) begin
                // a - b
                res = a + ~b + 1;
                // Ensure the MSB of the result is 0 (positive)
                res[N-1] = 0;
            end else begin
                // b - a
                res = ~a + b + 1;
                // If the result is negative, set the MSB accordingly
                if (res[N-1] == 0) begin
                    res = {1'b1, {N-1{1'b1}}};
                end
            end
        end else begin
            // a is negative, b is positive
            if (~a + 1 >= b) begin
                // b - a
                res = b + ~a + 1;
                // Ensure the MSB of the result is 0 (positive)
                res[N-1] = 0;
            end else begin
                // a - b
                res = ~b + a + 1;
                // If the result is negative, set the MSB accordingly
                if (res[N-1] == 0) begin
                    res = {1'b1, {N-1{1'b1}}};
                end
            end
        end
    end

    // Overflow handling
    if (res[N-1] == 1'b1 && a[N-1] == 1'b0 && b[N-1] == 1'b0) begin
        // Overflow occurred, saturate the result
        res = {1'b1, {N-1{1'b1}}};
    end else if (res[N-1] == 1'b0 && a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        // Underflow occurred, saturate the result
        res = {N{1'b0}};
    end

    c = res;
end

endmodule