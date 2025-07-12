module FloatForge(
    input clk, rst,
    input [31:0] a, b,
    output reg [31:0] z
);

// Stage 1: Mantissa Multiplication
reg [23:0] a_mantissa, b_mantissa;
reg [49:0] product;
always @(posedge clk) begin
    if (rst) begin
        product <= 0;
    end else begin
        a_mantissa <= a[22:0];
        b_mantissa <= b[22:0];
        product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
    end
end

// Stage 2: Exponent Calculation
reg [7:0] a_exponent, b_exponent, z_exponent;
always @(posedge clk) begin
    if (rst) begin
        z_exponent <= 0;
    end else begin
        a_exponent <= a[30:23];
        b_exponent <= b[30:23];
        z_exponent <= a_exponent + b_exponent - 8'd127;
    end
end

// Stage 3: Rounding and Exception Handling
reg [23:0] z_mantissa;
reg z_sign;
always @(posedge clk) begin
    if (rst) begin
        z_mantissa <= 0;
        z_sign <= 0;
    end else begin
        // Rounding Logic
        if (product[25]) begin // Guard bit
            if (product[24] || |product[23:0]) begin // Round bit or sticky
                z_mantissa <= product[49:26] + 1;
            end else begin
                z_mantissa <= product[49:26];
            end
        end else begin
            z_mantissa <= product[49:26];
        end
        
        // Exception Handling
        if (z_exponent > 8'd254) begin // Overflow
            z <= (a[31] ^ b[31])? 32'hff800000 : 32'h7f800000;
        end else if (z_exponent < 8'd1) begin // Underflow
            z <= {a[31] ^ b[31], 8'b0, z_mantissa};
        end else begin
            z_sign <= a[31] ^ b[31];
            z <= {z_sign, z_exponent, z_mantissa[22:0]};
        end
    end
end

endmodule