module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs
        res = a + b; // Add absolute values
    end else begin // Different signs
        if (a[N-1] == 1'b0) begin // a is positive
            if (a >= (b ^ {N{1'b1}} + 1'b1)) begin // a is larger
                res = a - (b ^ {N{1'b1}} + 1'b1); // a - (-b)
                res[N-1] = 1'b0; // Result is positive
            end else begin // b is larger
                res = (b ^ {N{1'b1}} + 1'b1) - a; // -b - a
                res[N-1] = res[N-1]; // Keep the sign bit
            end
        end else begin // a is negative
            if ((a ^ {N{1'b1}} + 1'b1) >= (b ^ {N{1'b1}} + 1'b1)) begin // -a is larger
                res = (a ^ {N{1'b1}} + 1'b1) - (b ^ {N{1'b1}} + 1'b1); // -a - (-b)
                res[N-1] = res[N-1]; // Keep the sign bit
            end else begin // -b is larger
                res = (b ^ {N{1'b1}} + 1'b1) - (a ^ {N{1'b1}} + 1'b1); // -b - (-a)
                res[N-1] = 1'b1; // Result is negative
            end
        end
    end
    // Overflow handling
    if (res[N-1]!= res[N-2]) begin
        if (res[N-1] == 1'b0) begin // Positive overflow
            res = {N{1'b1}};
        end else begin // Negative overflow
            res = {N{1'b0}};
        end
    end
    c = res;
end

endmodule