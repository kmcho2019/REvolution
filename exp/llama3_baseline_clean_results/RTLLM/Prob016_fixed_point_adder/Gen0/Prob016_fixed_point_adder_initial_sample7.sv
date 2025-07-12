module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

// Internal register to store the result
reg [N-1:0] res;

// Determine the operation based on the sign bits of a and b
always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign, perform addition
        res = a + b;
    end else begin // Different signs, perform subtraction
        if (a[N-1] == 1) begin // a is negative
            if (a < b) begin // b is greater
                res = b - a;
            end else begin // a is greater
                res = a - b;
            end
        end else begin // b is negative
            if (a < b) begin // b is greater (in absolute value)
                res = b - a;
            end else begin // a is greater
                res = a - b;
            end
        end
    end
end

// Output assignment
assign c = res;

endmodule