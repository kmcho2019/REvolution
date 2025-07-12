module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    // Determine signs of operands
    reg sign_a = a[N-1];
    reg sign_b = b[N-1];

    // Calculate absolute values
    reg [N-1:0] abs_a, abs_b;
    if (sign_a) begin
        abs_a = ~(a) + 1;
    end else begin
        abs_a = a;
    end

    if (sign_b) begin
        abs_b = ~(b) + 1;
    end else begin
        abs_b = b;
    end

    // Perform addition or subtraction based on signs
    reg [N:0] result;
    if (sign_a == sign_b) begin
        // Addition of absolute values
        result = abs_a + abs_b;
    end else begin
        // Subtraction of absolute values
        if (abs_a > abs_b) begin
            result = abs_a - abs_b;
        end else begin
            result = abs_b - abs_a;
        end
    end

    // Handle overflow and underflow
    if (result[N]) begin // Overflow
        if (sign_a) begin
            c = {N{1'b1}};
        end else begin
            c = {N{1'b0}};
        end
    end else begin
        // Set the sign of the result
        if ((sign_a == sign_b && result[N-1] == 1'b1) || (sign_a != sign_b && abs_a < abs_b)) begin
            c = ~(result[N-1:0]) + 1;
        end else begin
            c = result[N-1:0];
        end
    end
end

endmodule