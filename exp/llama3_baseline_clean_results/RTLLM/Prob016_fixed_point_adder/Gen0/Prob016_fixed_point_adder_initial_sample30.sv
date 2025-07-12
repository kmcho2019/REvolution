module fixed_point_adder #(parameter Q = 8, parameter N = 16)
    (input  [N-1:0] a,
     input  [N-1:0] b,
     output [N-1:0] c);

    reg [N-1:0] res;

    always @(*) begin
        // Determine the operation based on the signs of a and b
        if (a[N-1] == b[N-1]) begin // Same signs, perform addition
            // Add the absolute values of a and b
            res = a + b;
            // Ensure the sign bit of the result matches a and b
            if (a[N-1] == 1'b1) begin // Negative numbers
                res = -res;
            end
        end else begin // Different signs, perform subtraction
            // Determine which number has the larger absolute value
            if (a[N-1] == 1'b0) begin // a is positive, b is negative
                if (a > -b) begin // a > |b|
                    res = a + (~b + 1'b1); // a - b, result is positive
                end else begin
                    res = (~a + 1'b1) + b; // b - a, result is negative
                    res = -res; // Correct the sign
                end
            end else begin // a is negative, b is positive
                if (-a > b) begin // |a| > b
                    res = (~a + 1'b1) + b; // a - b, result is negative
                    res = -res; // Correct the sign
                end else begin
                    res = a + (~b + 1'b1); // b - a, result is positive
                end
            end
        end

        // Handle overflow
        if (res[N-1] == 1'b1 && res[N-2:N-Q] != 0) begin
            // Overflow, saturation needed
            if (res[N-1] == 1'b1) begin // Negative overflow
                res = {1'b1, {(N-1){1'b1}}};
            end else begin // Positive overflow
                res = {1'b0, {(N-1){1'b1}}};
            end
        end

        // Assign the result to the output
        c = res;
    end

endmodule