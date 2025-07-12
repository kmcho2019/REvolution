module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits
) (
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output signed [N-1:0] c
);

reg signed [N-1:0] res;

always @(a or b) begin
    // Determine the sign of the operands
    if (a[N-1] == b[N-1]) begin // Both operands have the same sign
        // Add the absolute values
        res = a + b;
    end else begin // Operands have different signs
        // Compare the absolute values
        if (a[N-1] == 1) begin // a is negative
            if (b[N-1] == 0) begin // b is positive
                if (a > b) begin
                    res = a - b;
                    if (res == 0) begin
                        res = 0;
                    end else begin
                        res = {1'b1, {N-1{1'b0}}}; // Overflow
                    end
                end else begin
                    res = b - a;
                    if (res == 0) begin
                        res = 0;
                    end else begin
                        res = {1'b0, {N-1{1'b0}}}; // No overflow in this case
                    end
                end
            end
        end else begin // a is positive
            if (b[N-1] == 1) begin // b is negative
                if (a > b) begin
                    res = a - b;
                    if (res == 0) begin
                        res = 0;
                    end else begin
                        res = {1'b0, {N-1{1'b0}}}; // No overflow in this case
                    end
                end else begin
                    res = b - a;
                    if (res == 0) begin
                        res = 0;
                    end else begin
                        res = {1'b1, {N-1{1'b0}}}; // Overflow
                    end
                end
            end
        end
    end

    // Assign the result to the output
    c = res;
end

endmodule