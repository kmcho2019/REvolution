module fixed_point_subtractor #(
    parameter Q = 8, // number of fractional bits
    parameter N = 16 // total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res; // internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // same sign subtraction
        res = a - b;
    end else begin // different sign subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a is positive, b is negative
            res = a + (~b + 1'b1); // add absolute values of a and b
            if (a >= (b + (~b + 1'b1))) begin // check if result is positive
                res[N-1] = 1'b0;
            end else begin
                res[N-1] = 1'b1;
            end
        end else begin // a is negative, b is positive
            res = (~a + 1'b1) + b; // add absolute values of a and b
            if ((~a + 1'b1) >= b) begin // check if result is negative
                res[N-1] = 1'b1;
            end else begin
                res[N-1] = 1'b0;
            end
        end
    end
    
    // handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule