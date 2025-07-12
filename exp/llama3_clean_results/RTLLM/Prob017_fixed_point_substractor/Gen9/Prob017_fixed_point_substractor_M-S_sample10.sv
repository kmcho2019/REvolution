module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output signed [N-1:0] c
);

always @(a, b) begin
    c = a - b;
    // Handle zero result
    if (c == 0) begin
        c = 0;
    end
end

endmodule