module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

reg [2:0] counter;
reg [23:0] a_mantissa, b_mantissa, z_mantissa;
reg [7:0] a_exponent, b_exponent, z_exponent;
reg a_sign, b_sign, z_sign;
reg [49:0] product;
reg guard_bit, round_bit, sticky;

// Initialization
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 3'b000;
    end else begin
        counter <= counter + 1'b1;
    end
end

// Input Processing
always @(posedge clk) begin
    if (counter == 3'b001) begin
        // Extract mantissas, exponents, and signs from inputs
        a_sign <= a[31];
        a_exponent <= a[30:23];
        a_mantissa <= {1'b1, a[22:0]};
        
        b_sign <= b[31];
        b_exponent <= b[30:23];
        b_mantissa <= {1'b1, b[22:0]};
    end
end

// Special Cases Handling
always @(posedge clk) begin
    if (counter == 3'b010) begin
        // Check for NaN and infinity
        if ((a_exponent == 8'hff && a_mantissa!= 24'h000000) || 
            (b_exponent == 8'hff && b_mantissa!= 24'h000000)) begin
            // Result is NaN or infinity
            z <= {a[31], 8'hff, 23'h000000};
        end
    end
end

// Normalization and Multiplication
always @(posedge clk) begin
    if (counter == 3'b011) begin
        // Normalize mantissas if needed
        if (a_mantissa[23] == 1'b0) begin
            a_mantissa <= {a_mantissa[22:0], 1'b0};
            a_exponent <= a_exponent - 1'b1;
        end
        if (b_mantissa[23] == 1'b0) begin
            b_mantissa <= {b_mantissa[22:0], 1'b0};
            b_exponent <= b_exponent - 1'b1;
        end
        
        // Multiply mantissas and adjust exponent
        product <= a_mantissa * b_mantissa;
        z_exponent <= a_exponent + b_exponent + 1'b1;
        z_sign <= a_sign ^ b_sign;
    end
end

// Rounding and Adjustment
always @(posedge clk) begin
    if (counter == 3'b100) begin
        // Perform rounding
        guard_bit <= product[48];
        round_bit <= product[47];
        sticky <= |product[46:0];
        
        if (guard_bit && (round_bit || sticky)) begin
            // Round up
            z_mantissa <= product[47:24] + 1'b1;
        end else begin
            z_mantissa <= product[47:24];
        end
        
        // Adjust exponent if overflow
        if (product[48] == 1'b1) begin
            z_exponent <= z_exponent + 1'b1;
        end
    end
end

// Output Generation
always @(posedge clk) begin
    if (counter == 3'b101) begin
        // Format result in IEEE-754 standard
        z <= {z_sign, z_exponent, z_mantissa[22:0]};
        
        // Handle overflow or underflow
        if (z_exponent > 8'hff - 1'b1) begin
            z <= {z_sign, 8'hff, 23'h000000}; // Overflow to infinity
        end else if (z_exponent < 1'b1) begin
            z <= {z_sign, 8'h00, 23'h000000}; // Underflow to zero
        end
    end
end

endmodule