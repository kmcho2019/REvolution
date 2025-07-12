module float_multi(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

reg [23:0] a_mantissa, b_mantissa;
reg [8:0] a_exponent, b_exponent;
reg a_sign, b_sign;

// Input Processing and Special Case Handling
always @(posedge clk) begin
    if (rst) begin
        a_mantissa <= 0;
        a_exponent <= 0;
        a_sign <= 0;
        b_mantissa <= 0;
        b_exponent <= 0;
        b_sign <= 0;
    end else begin
        a_mantissa <= a[22:0];
        a_exponent <= a[30:23];
        a_sign <= a[31];
        b_mantissa <= b[22:0];
        b_exponent <= b[30:23];
        b_sign <= b[31];
        
        // Simplified Special Case Handling
        if (a_exponent == 9'd255 || b_exponent == 9'd255) begin
            z <= (a_sign || b_sign)? 32'hff800000 : 32'h7f800000; // Infinity
        end else if (a_exponent == 0 || b_exponent == 0) begin
            z <= 32'b0; // Zero
        end
    end
end

// Mantissa Multiplication and Exponent Calculation
reg [49:0] product;
reg [8:0] z_exponent;
reg [23:0] z_mantissa;
reg z_sign;

always @(posedge clk) begin
    product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    z_exponent <= a_exponent + b_exponent - 9'd127;
    z_mantissa <= product[49:26];
    z_sign <= a_sign ^ b_sign;
end

// Rounding and Output Generation
reg guard_bit, round_bit, sticky;
always @(posedge clk) begin
    guard_bit <= product[25];
    round_bit <= product[24];
    sticky <= |product[23:0];
    
    if (round_bit && (guard_bit || sticky)) begin
        z_mantissa <= z_mantissa + 1;
    end
    
    if (z_exponent > 9'd254) begin
        z <= (z_sign)? 32'hff800000 : 32'h7f800000; // Overflow
    end else if (z_exponent < 9'd1) begin
        z <= {z_sign, 8'b0, z_mantissa}; // Underflow or denormalized
    end else begin
        z <= {z_sign, z_exponent, z_mantissa[22:0]}; // Normalized result
    end
end

endmodule