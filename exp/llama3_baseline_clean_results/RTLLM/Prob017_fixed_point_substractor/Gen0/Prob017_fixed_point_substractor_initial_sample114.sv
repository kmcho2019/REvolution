module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input  [N-1:0] a,
    input  [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Determine the signs of the inputs
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin  // Both positive
        if (a >= b) begin
            res = a - b;
        end else begin
            res = {1'b1, {N-1{1'b0}}} - (b - a);
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin  // Both negative
        if (a >= b) begin
            res = a - b;
        end else begin
            res = {1'b1, {N-1{1'b0}}} - (b - a);
        end
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin  // a positive, b negative
        res = a + (~b + 1'b1);
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // a negative, b positive
        res = (~a + 1'b1) + b;
    end

    // Handle the case where the result is zero
    if (res == {N{1'b0}}) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule