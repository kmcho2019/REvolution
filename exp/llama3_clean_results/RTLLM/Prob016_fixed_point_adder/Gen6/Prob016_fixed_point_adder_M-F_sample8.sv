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
    reg [N-1:0] abs_a = sign_a? ~a + 1 : a;
    reg [N-1:0] abs_b = sign_b? ~b + 1 : b;

    // Perform addition or subtraction based on signs
    reg [N:0] temp_res;
    if (sign_a == sign_b) begin
        temp_res = abs_a + abs_b;
    end else begin
        if (abs_a >= abs_b) begin
            temp_res = abs_a - abs_b;
        end else begin
            temp_res = abs_b - abs_a;
        end
    end

    // Handle overflow and underflow
    if (temp_res[N]) begin // Overflow
        c = {1'b1, {N-1{1'b1}}}; // Corrected syntax for generating a vector of ones
    end else if (temp_res[N-1] == 1'b1 && temp_res[N] == 1'b0) begin // Underflow condition adjustment
        c = {N{1'b0}};
    end else begin
        c = temp_res[N-1:0];
    end
end

endmodule