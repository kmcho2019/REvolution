module float_multi(
    input               clk,
    input               rst,
    input      [31:0]    a,
    input      [31:0]    b,
    output reg [31:0]    z
);

reg [2:0]           counter;
reg [23:0]          a_mantissa, b_mantissa, z_mantissa;
reg [7:0]           a_exponent, b_exponent, z_exponent;
reg                 a_sign, b_sign, z_sign;
reg [49:0]          product;
reg                 guard_bit, round_bit, sticky;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        counter         <= 3'd0;
        a_mantissa      <= 24'd0;
        b_mantissa      <= 24'd0;
        z_mantissa      <= 24'd0;
        a_exponent      <= 8'd0;
        b_exponent      <= 8'd0;
        z_exponent      <= 8'd0;
        a_sign          <= 1'd0;
        b_sign          <= 1'd0;
        z_sign          <= 1'd0;
        product         <= 50'd0;
        guard_bit       <= 1'd0;
        round_bit       <= 1'd0;
        sticky          <= 1'd0;
        z               <= 32'd0;
    end else begin
        case (counter)
            3'd0: begin
                // Input Processing: Extract mantissas, exponents, and sign bits
                a_mantissa  <= {a[22], a[21:0]};
                b_mantissa  <= {b[22], b[21:0]};
                a_exponent  <= a[30:23];
                b_exponent  <= b[30:23];
                a_sign      <= a[31];
                b_sign      <= b[31];
                counter     <= counter + 1;
            end
            3'd1: begin
                // Special Cases Handling: Check for NaN and infinity
                if ((a_exponent == 8'd255 && a_mantissa != 24'd0) || (b_exponent == 8'd255 && b_mantissa != 24'd0)) begin
                    // Result is NaN or infinity, set accordingly
                    z_exponent  <= 8'd255;
                    if (a_exponent == 8'd255 && a_mantissa != 24'd0)
                        z_mantissa  <= a_mantissa;
                    else if (b_exponent == 8'd255 && b_mantissa != 24'd0)
                        z_mantissa  <= b_mantissa;
                    else
                        z_mantissa  <= 24'd0; // For infinity
                    z_sign      <= a_sign ^ b_sign;
                    z_exponent  <= 8'd255;
                    counter     <= 3'd6;
                end else if (a_exponent == 8'd0 || b_exponent == 8'd0) begin
                    // Handle zero case
                    z_exponent  <= 8'd0;
                    z_mantissa  <= 24'd0;
                    z_sign      <= a_sign ^ b_sign;
                    counter     <= 3'd6;
                end else begin
                    // Normalization and Multiplication Preparation
                    a_mantissa  <= a_mantissa + 24'd1; // Normalize a
                    b_mantissa  <= b_mantissa + 24'd1; // Normalize b
                    counter     <= counter + 1;
                end
            end
            3'd2: begin
                // Multiplication: Multiply mantissas and combine signs
                product     <= {1'd0, a_mantissa} * {1'd0, b_mantissa};
                z_sign      <= a_sign ^ b_sign;
                z_exponent  <= a_exponent + b_exponent - 8'd127; // Adjust exponent
                counter     <= counter + 1;
            end
            3'd3: begin
                // Rounding and Adjustment: Round result and adjust exponent
                {guard_bit, round_bit, sticky}  <= product[49:47];
                if (guard_bit || round_bit || sticky) begin
                    // Round up
                    z_mantissa  <= product[46:23] + 24'd1;
                end else begin
                    z_mantissa  <= product[46:23];
                end
                if (z_mantissa[23]) begin
                    // Overflow, adjust exponent and mantissa
                    z_exponent  <= z_exponent + 1;
                    z_mantissa  <= z_mantissa >> 1;
                end
                counter     <= counter + 1;
            end
            3'd4: begin
                // Output Generation: Format result in IEEE 754
                z           <= {z_sign, z_exponent, z_mantissa[22:0]};
                counter     <= 3'd6;
            end
            3'd6: begin
                // Wait state before next operation
                counter     <= 3'd0;
            end
            default: begin
                counter     <= counter + 1;
            end
        endcase
    end
end

endmodule