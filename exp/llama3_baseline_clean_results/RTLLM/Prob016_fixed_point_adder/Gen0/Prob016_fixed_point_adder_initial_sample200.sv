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
    if (a[N-1] == b[N-1]) begin // If signs are the same
        // Add absolute values and set sign
        if (a[N-1] == 1'b0) begin // Both positive
            res = a + b;
        end else begin // Both negative
            res = -a - b;
        end
    end else begin // If signs are different
        // Perform absolute value subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
            if (a > -b) begin // a is greater
                res = a + b;
            end else begin // b is greater
                res = b + a;
            end
        end else begin // a is negative, b is positive
            if (-a > b) begin // a is greater
                res = -a - b;
            end else begin // b is greater
                res = b + a;
            end
        end
    end
    c = res;
end

endmodule