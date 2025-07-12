module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res;

// Determine the result based on the signs of a and b
assign res = (a[N-1] == b[N-1])? (a + b) : ((a[N-1] == 0)? (a + (~b + 1)) : ((~a + 1) + b));

// Saturate the result to handle overflows
always @(*) begin
    if (res[N-1] && ~a[N-1] && ~b[N-1]) begin
        // Positive overflow
        c = {1'b1, {(N-1){1'b1}}};
    end else if (~res[N-1] && a[N-1] && b[N-1]) begin
        // Negative overflow
        c = {1'b1, {(N-1){1'b0}}};
    end else begin
        // No overflow
        c = res;
    end
end

endmodule