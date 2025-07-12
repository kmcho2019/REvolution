module fixed_point_subtractor #(
    parameter Q = 16,  // number of fractional bits
    parameter N = 32  // total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

// calculate the result of the subtraction
always @(*) begin
    if (a[N-1] == b[N-1]) begin  // same sign subtraction
        res = a - b;
    end else begin  // different sign subtraction
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= ~b + 1) begin  // a is greater than b
                res = a + ~b + 1;
            end else begin  // a is less than b
                res = ~b + 1 - a;
            end
        end else begin  // a is negative, b is positive
            if (~a + 1 >= b) begin  // a is greater than b
                res = ~a + 1 + ~b + 1;
            end else begin  // a is less than b
                res = b - (~a + 1);
            end
        end
    end

    // handle the case when the result is zero
    if (res == 0) begin
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule