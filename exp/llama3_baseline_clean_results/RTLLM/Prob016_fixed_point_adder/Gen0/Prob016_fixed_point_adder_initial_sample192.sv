module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits (precision)
    parameter N = 16 // Total number of bits, including integer and fractional parts
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin // Same signs, add absolute values
        res = a + b;
        // MSB of result is set to match MSBs of a and b
        if (a[N-1] == 1'b1) begin // Both negative
            if (res[N-1] == 1'b0) begin // Result is positive, handle overflow
                res = {1'b1, {N-1{1'b1}}}; // Set result to maximum negative value
            end
        end else begin // Both positive
            if (res[N-1] == 1'b1) begin // Result is negative, handle overflow
                res = {N{1'b0}}; // Set result to 0
            end
        end
    end else begin // Different signs, perform subtraction
        if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin // a is negative, b is positive
            if (a > (~b + 1)) begin // a is greater than b
                res = a - (~b + 1);
            end else begin
                res = (~b + 1) - a;
            end
        end else begin // a is positive, b is negative
            if (a > (~b + 1)) begin // a is greater than b
                res = a - (~b + 1);
            end else begin
                res = (~b + 1) - a;
            end
        end
    end
end

assign c = res;

endmodule