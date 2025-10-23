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
    reg [N:0] temp_res; // Temporary result

    // Perform addition or subtraction based on sign
    if (sign_a == sign_b) begin
        // Same signs, add absolute values
        temp_res = (int_a * (1 << Q) + frac_a) + (int_b * (1 << Q) + frac_b);
    end else begin
        // Different signs, subtract
        if ((int_a * (1 << Q) + frac_a) >= (int_b * (1 << Q) + frac_b)) begin
            temp_res = (int_a * (1 << Q) + frac_a) - (int_b * (1 << Q) + frac_b);
        end else begin
            temp_res = (int_b * (1 << Q) + frac_b) - (int_a * (1 << Q) + frac_a);
        end
    end

    // Check for overflow
    if (temp_res >= (1 << N)) begin
        c = (1 << N) - 1;
    end else if (temp_res < 0) begin
        c = 0;
    end else begin
        // Extract integer and fractional parts from the result
        int_res = temp_res[N-1:Q];
        frac_res = temp_res[Q-1:0];

        // Combine integer and fractional parts
        c = {int_res, frac_res};
    end
end

endmodule