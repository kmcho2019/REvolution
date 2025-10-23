module fixed_point_subtractor #(
    parameter Q = 8, // number of fractional bits
    parameter N = 16 // total number of bits
) (
    input [N-1:0] a, // first input operand
    input [N-1:0] b, // second input operand
    output [N-1:0] c // result of subtraction
);

reg [N-1:0] res; // internal register to store result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // same sign subtraction
        res = a - b;
    end else begin // different sign subtraction
        if (a[N-1] == 0) begin // a is positive, b is negative
            res = a + (~b + 1); // add absolute values
        end else begin // a is negative, b is positive
            res = (~a + 1) + b; // add absolute values
        end
    end
    if (res == 0) begin // handle zero result
        c = {1'b0, {N-1{1'b0}}};
    end else begin
        c = res;
    end
end

endmodule