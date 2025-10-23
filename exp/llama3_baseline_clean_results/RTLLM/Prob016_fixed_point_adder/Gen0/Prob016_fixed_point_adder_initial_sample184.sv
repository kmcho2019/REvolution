module fixed_point_adder #(
    parameter Q = 16,  // Number of fractional bits (precision)
    parameter N = 32   // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// Perform absolute value addition or subtraction based on MSBs
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a + b;  // Add absolute values
    end else begin  // Different signs
        if (a[N-1] == 0) begin  // a is positive
            if (a >= (b ^ ((1 << N) - 1) + 1)) begin  // a is greater
                res = a - (b ^ ((1 << N) - 1) + 1);  // a - (-b)
            end else begin  // b is greater
                res = (b ^ ((1 << N) - 1) + 1) - a;  // -b - a
                res = res ^ ((1 << N) - 1) + 1;  // Convert back to negative
            end
        end else begin  // a is negative
            if ((a ^ ((1 << N) - 1) + 1) >= (b ^ ((1 << N) - 1) + 1)) begin  // a is greater
                res = (a ^ ((1 << N) - 1) + 1) - (b ^ ((1 << N) - 1) + 1);  // -a - (-b)
                res = res ^ ((1 << N) - 1) + 1;  // Convert back to negative
            end else begin  // b is greater
                res = (b ^ ((1 << N) - 1) + 1) - (a ^ ((1 << N) - 1) + 1);  // -b - (-a)
            end
        end
    end
end

// Assign result to output port
assign c = res;

endmodule