module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits
    parameter N = 32  // Total number of bits
) (
    input  wire [N-1:0] a,
    input  wire [N-1:0] b,
    output wire [N-1:0] c
);

reg [N-1:0] res;

// Determine the sign of the inputs
wire sign_a = a[N-1];
wire sign_b = b[N-1];

// Perform absolute value addition or subtraction
always @(*) begin
    if (sign_a == sign_b) begin
        // Absolute value addition
        res = a + b;
    end else begin
        // Absolute value subtraction
        if (a[N-1:Q] > b[N-1:Q]) begin
            // a is greater than b
            res = a - b;
        end else begin
            // b is greater than a
            res = b - a;
        end
    end
end

// Set the MSB of the result based on the signs of the inputs
always @(*) begin
    if (sign_a == sign_b) begin
        // Set the MSB of the result to match the MSBs of a and b
        c = {sign_a, res[N-2:0]};
    end else begin
        // Set the MSB of the result based on the result of the subtraction
        if (res[N-1] == 0) begin
            // Result is positive or zero
            c = res;
        end else begin
            // Result is negative
            c = {1'b1, res[N-2:0]};
        end
    end
end

endmodule