module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits (integer + fractional)
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register to store the result

assign c = res;  // Assign the result to the output port

always @(*) begin
    // Same sign subtraction
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0) || (a[N-1] == 1'b1 && b[N-1] == 1'b1)) begin
        res = a - b;
    end
    // Different sign subtraction
    else if (a[N-1] == 1'b0 && b[N-1] == 1'b1) begin
        if (a > (~b + 1)) begin
            res = a + (~b + 1);
        end else begin
            res = (~a + 1) + b;
            res = ~res + 1;  // Two's complement of the result
        end
    end
    else if (a[N-1] == 1'b1 && b[N-1] == 1'b0) begin
        if ((~a + 1) > b) begin
            res = (~a + 1) + (~b + 1);
            res = ~res + 1;  // Two's complement of the result
        end else begin
            res = a + (~b + 1);
        end
    end
    
    // Handle zero result
    if (res == 0) begin
        res[N-1] = 1'b0;  // Set sign bit to 0 for zero result
    end
end

endmodule