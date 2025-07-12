module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

// Determine the signs of a and b
wire a_sign = a[N-1];
wire b_sign = b[N-1];

// Calculate the sum or difference based on the signs of a and b
reg [N:0] res; // Extended bit width to handle overflow
always @(*) begin
    if (a_sign == b_sign) begin
        // Add absolute values
        res = {1'b0, a} + {1'b0, b};
    end else begin
        // Subtract smaller absolute value from larger one
        if ({a_sign, a} > {b_sign, b}) begin
            res = {1'b0, a} - {1'b0, b};
        end else begin
            res = {1'b0, b} - {1'b0, a};
        end
    end
    
    // Handle overflow and saturation
    if (res[N] == 1'b1) begin
        // Overflow, saturate at maximum value
        c = {N{1'b1}};
    end else if (res[N] == 1'b0) begin
        // No overflow, assign result
        c = res[N-1:0];
    end else begin
        // Handle underflow or zero result
        c = {N{1'b0}};
    end
end

endmodule