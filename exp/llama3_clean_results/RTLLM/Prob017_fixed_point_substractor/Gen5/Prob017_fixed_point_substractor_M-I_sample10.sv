module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Internal registers for storing the result
reg [N-1:0] res;

// Perform subtraction based on the signs of a and b
always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a is positive, b is negative
        if (a >= ~b + 1) begin  // a is greater than b
            res = a + ~b + 1;
        end else begin  // a is less than b
            res = ~(~a + b + 1);
        end
    end else begin  // a is negative, b is positive
        if (~a + 1 >= b) begin  // a is greater than b
            res = ~(~a + 1 - b);
        end else begin  // a is less than b
            res = b - (~a + 1);
        end
    end

    // Handle the zero result case
    if (res == 0) begin
        c[N-1] = 1'b0;  // Set the sign bit to 0
    end else begin
        c = res;
    end
end

endmodule