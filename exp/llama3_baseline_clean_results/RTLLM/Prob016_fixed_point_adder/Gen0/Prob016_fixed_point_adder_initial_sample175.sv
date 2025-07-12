module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // MSBs are the same (both positive or both negative)
        // Absolute value addition
        res = (a[N-1] == 1'b0) ? (a + b) : (-a + (-b));
    end else begin  // MSBs are different (one positive, one negative)
        // Determine the larger absolute value
        if (a[N-1] == 1'b0 && (a > ~b + 1)) || (a[N-1] == 1'b1 && (~a + 1 > b)) begin
            // a is greater than b
            res = a - (a[N-1] == 1'b0) ? b : (-b);
        end else begin
            // b is greater than a
            res = b - (b[N-1] == 1'b0) ? a : (-a);
            // Set MSB according to whether the result is zero or negative
            if (res == 0) begin
                res[N-1] = 1'b0;
            end else if (res[N-1] == 1'b1) begin
                // Negative result, keep MSB as is
            end
        end
    end

    // Ensure the MSB of the result matches the sign of the inputs (when both have the same sign)
    if (a[N-1] == b[N-1]) begin
        c[N-1] = a[N-1];
        c[N-2:0] = res[N-2:0];
    end else begin
        c = res;
    end
end

endmodule