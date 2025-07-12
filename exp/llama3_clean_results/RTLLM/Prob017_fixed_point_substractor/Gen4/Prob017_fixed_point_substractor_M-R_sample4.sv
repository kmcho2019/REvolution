module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Calculate the result directly based on the signs of a and b
assign c = (a[N-1] == b[N-1])? (a - b) : 
           (a[N-1] == 1'b0)? (a + (~b + 1'b1)) : (~a + 1'b1 + b);

// Explicitly handle the case where the result is zero
always @(c) begin
    if (c == 0) begin
        c <= {N{1'b0}};
    end
end

endmodule