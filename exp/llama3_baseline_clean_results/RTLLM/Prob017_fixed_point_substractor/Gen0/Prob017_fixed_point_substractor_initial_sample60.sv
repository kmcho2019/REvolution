module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)
(
    input [N-1:0] a,
    input [N-1:0] b,
    output [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Check if the signs of a and b are the same
    if ($signed(a[N-1]) == $signed(b[N-1])) begin
        // Same sign subtraction
        res = $signed(a) - $signed(b);
    end else begin
        // Different sign subtraction
        if ($signed(a) > $signed(b)) begin
            res = $signed(a) + (~$signed(b) + 1);
        end else begin
            res = (~$signed(a) + 1) + $signed(b);
        end
    end
    
    // Handle the edge case where the result is zero
    if (res == 0) begin
        res = {N{1'b0}};
    end
end

assign c = res;

endmodule