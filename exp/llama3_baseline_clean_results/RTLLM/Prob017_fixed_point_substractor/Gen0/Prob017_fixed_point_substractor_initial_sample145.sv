module fixed_point_subtractor #(
    parameter Q = 8,  // number of fractional bits
    parameter N = 16  // total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // same sign
        res = a - b;
        if (res == 0) begin  // handle zero result
            res[N-1] = 0;
        end
    end else if (a[N-1] == 0 && b[N-1] == 1) begin  // a is positive, b is negative
        if (a >= -b) begin
            res = a + ~b + 1;  // add absolute values and adjust sign
        end else begin
            res = ~a + b + 1;  // add absolute values and adjust sign
            res[N-1] = 1;  // set sign bit to 1
        end
        if (res == 0) begin  // handle zero result
            res[N-1] = 0;
        end
    end else if (a[N-1] == 1 && b[N-1] == 0) begin  // a is negative, b is positive
        if (-a >= b) begin
            res = ~a + b + 1;  // add absolute values and adjust sign
            res[N-1] = 1;  // set sign bit to 1
        end else begin
            res = a + ~b + 1;  // add absolute values and adjust sign
        end
        if (res == 0) begin  // handle zero result
            res[N-1] = 0;
        end
    end
    c = res;
end

endmodule