module fixed_point_subtractor #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output reg  [N-1:0] c
);

reg [N-1:0] res; // Internal register for result

always @(a or b) begin
    // Same sign subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        res = a - b;
    end
    // Different sign subtraction
    else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
        if (a > (~b + 1'b1)) begin
            res = a - (~b + 1'b1);
        end else begin
            res = (~a + 1'b1) - b;
            // Invert all bits and add 1 to get the two's complement
            res = ~res + 1'b1;
        end
    end else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
        if ((~a + 1'b1) > b) begin
            res = (~a + 1'b1) - b;
            // Invert all bits and add 1 to get the two's complement
            res = ~res + 1'b1;
        end else begin
            res = a - (~b + 1'b1);
        end
    end
    // Explicitly set sign bit to 0 when result is 0
    if (res == 0) begin
        res[N-1] = 1'b0;
    end
end

assign c = res;

endmodule