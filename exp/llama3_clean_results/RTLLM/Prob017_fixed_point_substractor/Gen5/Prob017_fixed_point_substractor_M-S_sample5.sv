module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

always @(a or b) begin
    if (a[N-1] == b[N-1]) begin
        // Same sign subtraction
        c = a - b;
    end else if (a[N-1] == 1'b0) begin
        // a is positive, b is negative
        c = a + (~b + 1'b1);
    end else begin
        // a is negative, b is positive
        c = (~a + 1'b1) + b;
    end
    
    // Handle zero result
    if (c == 0) begin
        c = {N{1'b0}};
    end
end

endmodule