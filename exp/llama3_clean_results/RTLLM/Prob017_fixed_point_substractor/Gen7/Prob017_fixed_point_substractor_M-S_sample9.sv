module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        c = a - b;
    end else begin  // Different sign subtraction
        if (a[N-1] == 1'b0 && a >= ~b + 1) begin  // a is positive, b is negative, a is greater
            c = a + (~b + 1);
        end else if (a[N-1] == 1'b0 && a < ~b + 1) begin  // a is positive, b is negative, b is greater
            c = (~a + 1) + b;
            c[N-1] = 1'b1;  // Set sign bit to negative
        end else if (a[N-1] == 1'b1 && ~a + 1 >= b) begin  // a is negative, b is positive, a is greater in absolute value
            c = (~a + 1) + b;
        end else begin  // a is negative, b is positive, b is greater in absolute value
            c = a + (~b + 1);
            c[N-1] = 1'b0;  // Set sign bit to positive
        end
    end
    
    // Handle the zero result case directly in the output assignment
    if (c == 0) begin
        c = {N{1'b0}};
    end
end

endmodule