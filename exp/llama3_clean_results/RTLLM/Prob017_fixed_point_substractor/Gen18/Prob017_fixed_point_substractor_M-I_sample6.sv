module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Continuous assignment for subtraction with explicit zero handling
always @(*) begin
    if (a == 0 && b == 0) begin
        c = 0;
    end else if (a == 0) begin
        c = -b;
    end else if (b == 0) begin
        c = a;
    end else begin
        c = a - b;
    end
end

endmodule