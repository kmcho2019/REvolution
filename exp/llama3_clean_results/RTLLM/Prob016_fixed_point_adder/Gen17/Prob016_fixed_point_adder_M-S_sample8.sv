module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input signed [N-1:0] a,
    input signed [N-1:0] b,
    output reg signed [N-1:0] c
);

always @(*) begin
    // Directly add the operands
    c = a + b;
    
    // Check for overflow and saturate if necessary
    if (c[N-1] != c[N-2]) begin
        if (c[N-1]) begin
            c = {-1, {N-1{1'b1}}};
        end else begin
            c = {N{1'b0}};
        end
    end
end

endmodule