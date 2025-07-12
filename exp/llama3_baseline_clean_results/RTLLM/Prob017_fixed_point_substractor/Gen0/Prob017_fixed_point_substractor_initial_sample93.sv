module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign
        res = a - b;
        if (res == 0) begin
            res = {1'b0, {N-1{1'b0}}};  // Handle zero result
        end
    end else begin  // Different signs
        if (a[N-1] == 1'b0) begin  // a is positive, b is negative
            res = a + (~b + 1'b1);
            if (res[N-1] == 1'b1) begin  // Result is negative
                res = {1'b1, {N-1{1'b0}}};  // Set sign bit to 1
            end else begin
                res = {1'b0, res[N-2:0]};  // Set sign bit to 0
            end
        end else begin  // a is negative, b is positive
            res = (~a + 1'b1) + b;
            if (res[N-1] == 1'b1) begin  // Result is negative
                res = {1'b1, {N-1{1'b0}}};  // Set sign bit to 1
            end else begin
                res = {1'b0, res[N-2:0]};  // Set sign bit to 0
            end
        end
    end
    if (res == 0) begin
        res = {1'b0, {N-1{1'b0}}};  // Handle zero result
    end
    c = res;
end

endmodule