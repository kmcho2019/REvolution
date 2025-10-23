module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin  // Same signs
        // Absolute value addition
        if (a[N-1] == 1'b0) begin  // Both positive
            res = a + b;
        end else begin  // Both negative
            res = -a + (-b);
            if (res[N-1] == 1'b0) begin  // Check for overflow
                res = {1'b1, {N-1{1'b1}}};
            end
        end
    end else begin  // Different signs
        // Absolute value subtraction
        if (a > b) begin  // a is greater than b
            res = a - b;
            if (res[N-1] == 1'b1 && a[N-1] == 1'b0) begin  // Check for overflow
                res = {N{1'b1}};
            end
        end else if (b > a) begin  // b is greater than a
            res = b - a;
            if (res[N-1] == 1'b1 && b[N-1] == 1'b0) begin  // Check for overflow
                res = {N{1'b1}};
            end
        end else begin  // a and b are equal
            res = 0;
        end
    end
end

assign c = res;

endmodule