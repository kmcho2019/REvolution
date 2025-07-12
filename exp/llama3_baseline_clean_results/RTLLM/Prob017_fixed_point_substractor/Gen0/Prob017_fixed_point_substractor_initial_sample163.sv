module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer and fractional)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    // Same Sign Subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        // Subtract fractional and integer parts
        res = a - b;
    end else begin
        // Different Sign Subtraction
        if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
            // Add absolute values
            res = a + (~b + 1'b1);
        end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
            // Add absolute values
            res = (~a + 1'b1) + b;
        end
    end

    // Handle zero result edge case
    if (res == 0) begin
        res[N-1] = 1'b0;  // Explicitly set sign bit to 0
    end
end

assign c = res;

endmodule