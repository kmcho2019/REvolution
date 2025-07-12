module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Internal register to store the result
reg [N-1:0] res;

// Perform addition
always @(*) begin
    res = a + b;
    
    // Check for overflow
    if (res >= (1 << N)) begin
        // Handle overflow, for simplicity, let's just set the MSB
        c = {1'b1, {N-1{1'b0}}};
    end else if (res < 0) begin
        // Handle underflow, for simplicity, let's just set the result to 0
        c = {N{1'b0}};
    end else begin
        // No overflow or underflow, directly assign the result
        c = res;
    end
end

endmodule