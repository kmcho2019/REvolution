module fixed_point_adder #(
    parameter N = 32, // Total number of bits
    parameter Q = 16  // Number of fractional bits
) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

    reg [N-1:0] res; // Internal register to store the result

    always @(*) begin
        if (a[N-1] == b[N-1]) begin // Same signs
            // Absolute value addition
            res = a + b;
            if (res >= (1 << N)) begin // Overflow check
                res = (1 << N) - 1; // Saturate at maximum value
            end
        end else begin // Different signs
            if (a[N-1] == 1) begin // a is negative
                if (b >= -a) begin // b's absolute value is larger
                    res = b + (~a + 1); // b - a
                    if (res[N-1] == 0) begin // Result is positive
                        res = res;
                    end else begin // Result is negative
                        res = -res; // Invert to maintain correct sign
                    end
                end else begin // a's absolute value is larger
                    res = (~b + 1) + a; // a - b
                end
            end else begin // b is negative
                if (a >= -b) begin // a's absolute value is larger
                    res = a + (~b + 1); // a - b
                end else begin // b's absolute value is larger
                    res = (~a + 1) + b; // b - a
                    if (res[N-1] == 0) begin // Result is positive
                        res = res;
                    end else begin // Result is negative
                        res = -res; // Invert to maintain correct sign
                    end
                end
            end
        end
        c = res;
    end

endmodule