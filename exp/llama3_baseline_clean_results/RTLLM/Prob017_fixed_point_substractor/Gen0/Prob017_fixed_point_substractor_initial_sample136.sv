module fixed_point_subtractor #(
    parameter Q = 16, // number of fractional bits
    parameter N = 32 // total number of bits
)(
    input logic [N-1:0] a,
    input logic [N-1:0] b,
    output logic [N-1:0] c
);

logic [N-1:0] res; // internal register to store the result

always_comb begin
    // sign bits of a and b
    logic a_sign = a[N-1];
    logic b_sign = b[N-1];

    // same sign subtraction
    if (a_sign == b_sign) begin
        // subtract b from a, preserving the sign
        res = a - b;
        // if the result is zero, explicitly set the sign bit to 0
        if (res == 0) begin
            res[N-1] = 0;
        end
    end
    // different sign subtraction
    else begin
        // if a is positive and b is negative, add the absolute values of a and b
        if (!a_sign && b_sign) begin
            res = a + (~b + 1);
            // if a is greater than b, the result will be positive
            if (a > (b ^ {N-1{1'b1}})) begin
                res[N-1] = 0;
            end
            // if a is not greater than b, the result will be negative
            else begin
                res[N-1] = 1;
            end
        end
        // if a is negative and b is positive, add the absolute values of a and b
        else if (a_sign && !b_sign) begin
            res = (~a + 1) + b;
            // if a is greater than b, the result will be negative
            if ((~a + 1) > b) begin
                res[N-1] = 1;
            end
            // if a is not greater than b, the result will be positive
            else begin
                res[N-1] = 0;
            end
        end
        // if the result is zero, explicitly set the sign bit to 0
        if (res == 0) begin
            res[N-1] = 0;
        end
    end
end

assign c = res;

endmodule