module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else begin // Different sign subtraction
        if (a[N-1] == 0) begin // a is positive, b is negative
            res = a + (~b + 1'b1); // Add the two's complement of b to a
        end else begin // a is negative, b is positive
            res = (~a + 1'b1) + b; // Add the two's complement of a to b
        end
    end
    
    if (res == 0) begin // Handle zero result
        c = 0;
    end else begin
        c = res;
    end
end

endmodule