module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-Q-1:0] int_a, int_b; // Integer parts of a and b
reg [Q-1:0] frac_a, frac_b; // Fractional parts of a and b
reg [N-Q-1:0] int_res; // Result of integer part operation
reg [Q-1:0] frac_res; // Result of fractional part operation
reg carry; // Carry from fractional part to integer part
reg sign_a, sign_b; // Signs of a and b

// Separate integer and fractional parts
assign int_a = a[N-1:Q];
assign int_b = b[N-1:Q];
assign frac_a = a[Q-1:0];
assign frac_b = b[Q-1:0];

// Determine signs of a and b
assign sign_a = a[N-1];
assign sign_b = b[N-1];

always @(*) begin
    // Perform addition or subtraction based on sign
    if (sign_a == sign_b) begin
        // Same signs, add absolute values
        int_res = int_a + int_b;
        frac_res = frac_a + frac_b;
    end else begin
        // Different signs, subtract
        if (int_a >= -int_b) begin
            int_res = int_a - int_b;
            frac_res = frac_a - frac_b;
        end else begin
            int_res = -int_b - int_a;
            frac_res = frac_b - frac_a;
        end
    end

    // Check for carry from fractional part to integer part
    carry = (frac_res >= (1 << Q)) ? 1'b1 : 1'b0;
    int_res = int_res + carry;

    // Combine integer and fractional parts
    c = {int_res, frac_res[Q-1:0]};

    // Handle overflow
    if (c >= (1 << N) - 1) begin
        c = (1 << N) - 1;
    end else if (c < 0) begin
        c = 0;
    end

    // Set the sign of the result
    if (sign_a == 1'b1 && sign_b == 1'b1) begin
        c[N-1] = 1'b1;
    end else if (sign_a == 1'b0 && sign_b == 1'b0) begin
        c[N-1] = 1'b0;
    end else begin
        // Different signs, result sign depends on the operation
        if (int_a >= -int_b) begin
            c[N-1] = 1'b0;
        end else begin
            c[N-1] = 1'b1;
        end
    end
end

endmodule