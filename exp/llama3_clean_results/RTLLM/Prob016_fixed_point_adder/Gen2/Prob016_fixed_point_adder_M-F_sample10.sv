module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result
reg [N-Q-1:0] int_a, int_b; // Integer parts of a and b
reg [Q-1:0] frac_a, frac_b; // Fractional parts of a and b
reg [N-Q-1:0] int_res; // Result of integer part operation
reg [Q-1:0] frac_res; // Result of fractional part operation
reg carry; // Carry from fractional part to integer part

always @(*) begin
    // Separate integer and fractional parts
    int_a = a[N-1:Q];
    int_b = b[N-1:Q];
    frac_a = a[Q-1:0];
    frac_b = b[Q-1:0];

    // Perform addition or subtraction on integer parts
    if (a[N-1] == b[N-1]) begin
        // Same signs, add absolute values
        int_res = (a[N-1] == 1'b0) ? (int_a + int_b) : -(int_a + int_b);
    end else begin
        // Different signs, subtract
        if ((int_a > int_b && a[N-1] == 1'b0) || (int_a < int_b && a[N-1] == 1'b1)) begin
            int_res = (a[N-1] == 1'b0) ? (int_a - int_b) : -(int_b - int_a);
        end else begin
            int_res = (a[N-1] == 1'b0) ? (int_b - int_a) : -(int_a - int_b);
        end
    end

    // Perform addition on fractional parts
    frac_res = frac_a + frac_b;

    // Check for carry from fractional part to integer part
    carry = (frac_res >= (1 << Q)) ? 1'b1 : 1'b0;
    int_res = int_res + carry;

    // Combine integer and fractional parts
    res = {int_res, frac_res[Q-1:1]};

    // Handle overflow and underflow
    if (res >= (1 << (N-1))) begin
        res = (1 << (N-1)) - 1;
    end else if (res < -(1 << (N-1))) begin
        res = -(1 << (N-1));
    end

    // Set the sign of the result based on the most significant bits of inputs
    if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        res[N-1] = 1'b1;
    end else if (a[N-1] == 1'b0 && b[N-1] == 1'b0) begin
        res[N-1] = 1'b0;
    end else begin
        // For different signs, the sign of the result depends on the operation
        res[N-1] = (int_a >= int_b) ? 1'b0 : 1'b1;
    end

    c = res; // Assign the result to the output port
end

endmodule