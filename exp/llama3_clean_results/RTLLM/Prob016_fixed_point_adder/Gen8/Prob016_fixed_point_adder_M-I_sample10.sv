module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

always @(*) begin
    reg [N-1:0] abs_a, abs_b;
    reg [N-1:0] temp_res;

    // Determine signs and calculate absolute values directly
    if (a[N-1]) begin
        abs_a = ~a + 1;
    end else begin
        abs_a = a;
    end

    if (b[N-1]) begin
        abs_b = ~b + 1;
    end else begin
        abs_b = b;
    end

    // Perform addition or subtraction based on signs
    if (a[N-1] == b[N-1]) begin
        temp_res = abs_a + abs_b;
    end else if (abs_a >= abs_b) begin
        temp_res = abs_a - abs_b;
        // Since we're subtracting a smaller from a larger, the result is positive
    end else begin
        temp_res = abs_b - abs_a;
        // For negative results, flip the MSB
        if (temp_res == 0) begin
            // If result is zero, no need to flip MSB
        end else begin
            temp_res[N-1] = 1'b1; // Set MSB to indicate negative result
        end
    end

    // Handle overflow by saturation
    if (temp_res[N-1] != a[N-1] && temp_res[N-1] != b[N-1]) begin
        // Overflow condition detected
        if (a[N-1] == 1'b1) begin
            c = {N{1'b1}}; // Saturate to maximum negative value
        end else begin
            c = {1'b0, {N-1{1'b1}}}; // Saturate to maximum positive value
        end
    end else begin
        c = temp_res;
    end
end

endmodule