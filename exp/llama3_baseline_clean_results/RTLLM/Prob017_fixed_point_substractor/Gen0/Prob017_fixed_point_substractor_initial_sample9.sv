module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32   // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same sign subtraction
        res = a - b;
    end else begin // Different sign subtraction
        if (a[N-1] == 1'b0) begin // a is positive, b is negative
            if (a > (~b + 1)) begin // a is greater than b
                res = a + (~b + 1);
            end else begin // a is less than or equal to b
                res = (~b + 1) - a;
                res = ~res + 1; // Two's complement
            end
        end else begin // a is negative, b is positive
            if ((~a + 1) > b) begin // a is greater than b (in absolute value)
                res = (~a + 1) - b;
                res = ~res + 1; // Two's complement
            end else begin // a is less than or equal to b
                res = b - (~a + 1);
            end
        end
    end

    if (res == {N{1'b0}} || res == {N{1'b1}}) begin // Handling zero
        res = {N{1'b0}};
    end

    c = res; // Assign result to output port
end

endmodule