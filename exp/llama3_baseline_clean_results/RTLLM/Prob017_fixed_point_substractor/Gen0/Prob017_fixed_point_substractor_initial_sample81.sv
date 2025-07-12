module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin // Both positive
        res = a - b;
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin // Both negative
        res = a - b;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin // a positive, b negative
        if (a < ~b + 1'b1) begin
            res = (~a + 1'b1) + b;
        end else begin
            res = a + (~b + 1'b1);
        end
    end else begin // a negative, b positive
        if (~a + 1'b1 < b) begin
            res = (~b + 1'b1) + a;
        end else begin
            res = (~a + 1'b1) + b;
        end
    end

    // Handle zero result
    if (res == 0) begin
        c = {N{1'b0}};
    end else begin
        c = res;
    end
end

endmodule