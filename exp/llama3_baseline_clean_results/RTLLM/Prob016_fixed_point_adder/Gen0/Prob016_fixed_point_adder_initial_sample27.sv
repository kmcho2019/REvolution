module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   [N-1:0] a,
    input   [N-1:0] b,
    output  [N-1:0] c
);

reg [N-1:0] res;

always @(*) begin
    if (a[N-1] == b[N-1]) begin  // Same sign, perform addition
        res = a + b;
    end else begin  // Different signs, perform subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (a < b) begin
                res = b - a;
            end else begin
                res = a - b;
                res[N-1] = 1'b1;  // Make sure the result is negative
            end
        end else begin  // a is positive
            if (a < b) begin
                res = b - a;
            end else begin
                res = a - b;
            end
        end
    end
    
    // Overflow handling, simplify by checking if the MSB flipped
    if ((a[N-1] == 1'b0 && b[N-1] == 1'b0 && res[N-1] == 1'b1) || (a[N-1] == 1'b1 && b[N-1] == 1'b1 && res[N-1] == 1'b0)) begin
        // Handle overflow
        res = {N{1'b1}};
    end
    
    c = res;
end

endmodule