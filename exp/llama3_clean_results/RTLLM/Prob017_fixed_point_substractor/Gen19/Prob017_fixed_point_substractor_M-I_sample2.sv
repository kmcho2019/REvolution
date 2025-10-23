module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

// Simplified logic to minimize computations and conditional checks
always @(*) begin
    if (a == 0 && b == 0) begin
        c = 0;
    end else begin
        // Direct subtraction, which handles same and different sign cases
        c = a - b;
    end
end

endmodule