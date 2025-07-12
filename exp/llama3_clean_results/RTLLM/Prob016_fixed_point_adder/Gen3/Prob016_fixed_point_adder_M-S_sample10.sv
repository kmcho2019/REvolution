module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

reg [N-1:0] res; // Internal register to store the result

always @(*) begin
    // Separate integer and fractional parts directly from inputs
    reg [N-Q-1:0] int_a = a[N-1:Q];
    reg [N-Q-1:0] int_b = b[N-1:Q];
    reg [Q-1:0] frac_a = a[Q-1:0];
    reg [Q-1:0] frac_b = b[Q-1:0];

    // Perform addition or subtraction based on signs
    reg [N-Q:0] int_res;
    if (a[N-1] == b[N-1]) begin
        // Same signs, add absolute values
        int_res = int_a + int_b;
    end else begin
        // Different signs, subtract
        if (int_a > int_b) begin
            int_res = int_a - int_b;
        end else begin
            int_res = int_b - int_a;
        end
    end

    // Perform addition on fractional parts
    reg [Q:0] frac_res = frac_a + frac_b;

    // Combine integer and fractional parts with carry
    res = {int_res + frac_res[Q], frac_res[Q-1:0]};

    // Handle overflow and underflow
    if (res >= (1 << (N-1))) begin
        res = (1 << (N-1)) - 1;
    end else if (res < -(1 << (N-1))) begin
        res = -(1 << (N-1));
    end

    // Set the sign of the result based on the operation
    if (a[N-1] == 1'b1 && b[N-1] == 1'b1) begin
        res[N-1] = 1'b1;
    end else if (int_a >= int_b) begin
        res[N-1] = 1'b0;
    end else begin
        res[N-1] = 1'b1;
    end

    c = res; // Assign the result to the output port
end

endmodule