module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    if (a == 0 && b == 0) begin
        c = {N{1'b0}};
    end else if (a[N-1] == b[N-1]) begin
        // Same sign, perform subtraction
        c = a - b;
    end else if (a[N-1] == 1'b0) begin
        // a is positive, b is negative, perform addition
        c = a + (~b + 1'b1);
    end else begin
        // a is negative, b is positive, perform subtraction with sign adjustment
        c = (~a + 1'b1) + b;
    end
end

endmodule