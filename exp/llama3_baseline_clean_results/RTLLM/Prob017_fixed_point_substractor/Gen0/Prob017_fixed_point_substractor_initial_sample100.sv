module fixed_point_subtractor #(
    parameter Q = 16,  // number of fractional bits
    parameter N = 32   // total number of bits
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;  // internal register to store the result

always @(*) begin
    // check if a and b have the same sign
    if (a[N-1] == b[N-1]) begin
        // same sign subtraction
        res = a - b;
    end else begin
        // different sign subtraction
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            if (a > (~b + 1'b1)) begin
                // a is greater than b, result is positive
                res = a + (~b + 1'b1);
            end else begin
                // a is less than b, result is negative
                res = ~(~a + b) + 1'b1;
            end
        end else begin  // a is negative, b is positive
            if (~a + 1'b1 > b) begin
                // a is greater than b, result is negative
                res = ~(~a + b) + 1'b1;
            end else begin
                // a is less than b, result is positive
                res = b + (~a + 1'b1);
            end
        end
    end
    
    // handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // set sign bit to 0
    end
end

assign c = res;

endmodule