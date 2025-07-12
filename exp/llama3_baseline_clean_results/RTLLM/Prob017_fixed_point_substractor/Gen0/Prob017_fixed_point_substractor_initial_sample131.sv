module fixed_point_subtractor #(
    parameter Q = 8,  // number of fractional bits
    parameter N = 16  // total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // same sign
        res = a - b;
    end else begin  // different signs
        if (a[N-1] == 0) begin  // a is positive, b is negative
            if (a >= b) begin
                res = a + (~b + 1);  // add absolute values
            end else begin
                res = (~a + 1) + b;  // add absolute values
                res = ~res + 1;  // two's complement for negative result
            end
        end else begin  // a is negative, b is positive
            if (b >= a) begin
                res = b + (~a + 1);  // add absolute values
            end else begin
                res = (~b + 1) + a;  // add absolute values
                res = ~res + 1;  // two's complement for negative result
            end
        end
    end
    
    // handle zero result
    if (res == 0) begin
        c[N-1] = 0;  // explicitly set sign bit to 0 for zero result
    end else begin
        c = res;
    end
end

endmodule