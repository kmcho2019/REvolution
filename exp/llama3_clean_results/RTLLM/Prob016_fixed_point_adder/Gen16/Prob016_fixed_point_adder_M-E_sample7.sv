module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N:0] temp; // Temporary register for addition result
reg [N-1:0] res; // Result register

always @(*) begin
    // Conditionally invert b if it's negative
    temp = a + (b[N-1] ? -b : b);
    
    // Check for overflow
    if (temp[N] != a[N-1]) begin
        // Saturate result if overflow occurs
        if (a[N-1]) begin
            res = {N{1'b1}};
        end else begin
            res = {N{1'b0}};
        end
    end else begin
        // Assign result if no overflow
        res = temp[N-1:0];
    end
end

assign c = res;

endmodule