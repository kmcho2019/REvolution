module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

// Internal signals
reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialize the counter on reset
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1;
    end
end

// Input processing during the first clock cycle
always @(posedge clk) begin
    if (counter == 3'b001) begin
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= a[22:0];

        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= b[22:0];
    end
end

// Special cases handling
always @(posedge clk) begin
    if (counter == 3'b010) begin
        if ((a_exponent == 8'b11111111) || (b_exponent == 8'b11111111)) begin
            // Handle infinity and NaN cases
            z <= (a_exponent == 8'b11111111) ? a : b;
        end else if ((a_exponent == 8'b00000000) || (b_exponent == 8'b00000000)) begin
            // Handle zero cases
            z <= 32'b0;
        end
    end
end

// Normalization
always @(posedge clk) begin
    if (counter == 3'b011) begin
        if (a_exponent != 8'b00000000) begin
            a_mantissa <= {1'b1, a_mantissa};
        end
        if (b_exponent != 8'b00000000) begin
            b_mantissa <= {1'b1, b_mantissa};
        end
    end
end

// Multiplication
always @(posedge clk) begin
    if (counter == 3'b100) begin
        product <= {1'b0, a_mantissa} * {1'b0, b_mantissa};
        z_sign <= a_sign ^ b_sign;
        z_exponent <= a_exponent + b_exponent - 8'b01111111;
    end
end

// Rounding and adjustment
always @(posedge clk) begin
    if (counter == 3'b101) begin
        {guard_bit, round_bit, sticky} <= product[49:47];
        if (round_bit || (guard_bit && sticky)) begin
            z_mantissa <= product[46:24] + 1;
        end else begin
            z_mantissa <= product[46:24];
        end
        if (z_mantissa[23]) begin
            z_mantissa <= {1'b0, z_mantissa[22:0]};
            z_exponent <= z_exponent + 1;
        end
    end
end

// Output generation
always @(posedge clk) begin
    if (counter == 3'b110) begin
        z <= {z_sign, z_exponent, z_mantissa[22:0]};
    end
end

endmodule