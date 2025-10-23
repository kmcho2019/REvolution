module fixed_point_subtractor #(
    parameter Q = 16,  // Number of fractional bits
    parameter N = 32    // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    // Direct subtraction using two's complement
    c = a - b;
    
    // Explicit zero handling (optional but maintains exact behavior)
    if (c == {N{1'b0}}) begin
        c = {N{1'b0}};  // Force positive zero
    end
end

endmodule