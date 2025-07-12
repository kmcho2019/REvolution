module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  signed [N-1:0] a,
    input  signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(a or b) begin
    c = a - b;
    
    // Handle edge cases using parametric values
    if (c > (1 << (N - 1)) - 1) begin
        c = (1 << (N - 1)) - 1;
    end else if (c < -(1 << (N - 1))) begin
        c = -(1 << (N - 1));
    end else if (c == 0) begin
        c = 0;
    end
end

endmodule