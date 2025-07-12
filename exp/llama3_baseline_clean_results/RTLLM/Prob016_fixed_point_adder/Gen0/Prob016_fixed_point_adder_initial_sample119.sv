module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;  // Register to store the result

always @(*) begin
    // Determine operation based on MSBs of a and b
    if (a[N-1] == b[N-1]) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1] == 1 && b[N-1] == 0) begin
            // a is negative, b is positive
            if (a < b) begin
                // b is larger
                res = ~a + 1 + b;
            end else begin
                // a is larger
                res = a - b;
            end
        end else begin
            // a is positive, b is negative
            if (a < b) begin
                // b is larger
                res = ~b + 1 + a;
            end else begin
                // a is larger
                res = a - b;
            end
        end
    end

    // Manage sign bit
    if (res[N-1] == 1) begin
        c = {N{1'b1}};  // Overflow, set all bits to 1
    end else begin
        c = res;
    end
end

endmodule