module fixed_point_adder #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input   wire [N-1:0] a,
    input   wire [N-1:0] b,
    output  wire [N-1:0] c
);

reg [N-1:0] res;  // Internal register for the result

always @(a or b) begin
    // Determine the signs of the input operands
    wire sign_a = a[N-1];
    wire sign_b = b[N-1];

    // Perform absolute value addition or subtraction based on the signs
    if (sign_a == sign_b) begin
        // Addition
        res = a + b;
    end else begin
        // Subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            // a is greater than b, perform a - b
            res = a - b;
        end else begin
            // b is greater than a, perform b - a
            res = b - a;
        end
    end

    // Handle overflow by checking the MSB of the result
    if (res[N-1]!= sign_a && sign_a == sign_b) begin
        // Overflow occurred, adjust the result to fit within the N-bit range
        if (sign_a) begin
            // Negative overflow
            res = {1'b1, {N-1{1'b1}}};
        end else begin
            // Positive overflow
            res = {1'b0, {N-1{1'b1}}};
        end
    end

    // Assign the result to the output port
    c = res;
end

endmodule