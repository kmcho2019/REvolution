module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits (precision)
    parameter N = 16  // Total number of bits, including integer and fractional parts
)(
    input  wire [N-1:0] a,  // First N-bit fixed-point input operand
    input  wire [N-1:0] b,  // Second N-bit fixed-point input operand
    output wire [N-1:0] c   // N-bit output representing the result of the fixed-point addition
);

reg [N-1:0] res;  // N-bit register used to store the result of the addition or subtraction

always @(a, b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign, perform absolute value addition
        res = a + b;
    end else begin  // Different signs, perform absolute value subtraction
        if (a[N-1] == 1) begin  // a is negative
            if (b[N-1] == 0) begin  // b is positive
                if (a[N-1:0] > b[N-1:0]) begin  // a is larger in absolute value
                    res = a - b;
                end else begin
                    res = b - a;
                    if (res == 0) begin
                        res[N-1] = 0;  // Set sign bit to 0 if result is 0
                    end else begin
                        res[N-1] = 1;  // Set sign bit to 1 if result is negative
                    end
                end
            end else begin  // Both are negative
                if (a[N-1:0] < b[N-1:0]) begin  // a is larger in absolute value
                    res = a - b;
                end else begin
                    res = b - a;
                end
            end
        end else begin  // a is positive
            if (b[N-1] == 1) begin  // b is negative
                if (a[N-1:0] > b[N-1:0]) begin  // a is larger in absolute value
                    res = a - b;
                end else begin
                    res = b - a;
                end
            end else begin  // Both are positive
                res = a + b;
            end
        end
    end
    
    // Handle overflow
    if (res[N-1] == 1 && res[N-2:0] == 0) begin
        // Maximum negative value
        res = {1'b1, {N-1{1'b0}}};
    end else if (res[N-1] == 0 && res[N-2:0] == {N-1{1'b1}}) begin
        // Maximum positive value
        res = {1'b0, {N-1{1'b1}}};
    end
end

assign c = res;

endmodule