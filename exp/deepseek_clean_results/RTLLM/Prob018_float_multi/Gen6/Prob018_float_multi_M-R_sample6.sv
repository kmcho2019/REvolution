module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline control
    reg [2:0] counter;
    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 0;
        else if (counter < 3) counter <= counter + 1;
        else counter <= 0;
    end

    // Internal registers
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [9:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;

    // Stage 0: Input processing and special cases
    always @(posedge clk) begin
        if (counter == 0) begin
            a_sign <= a[31];
            b_sign <= b[31];
            a_exponent <= {2'b0, a[30:23]};
            b_exponent <= {2'b0, b[30:23]};
            
            // Handle denormals (exponent=0)
            a_mantissa <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
        end
    end

    // Stage 1: Multiplication
    always @(posedge clk) begin
        if (counter == 1) begin
            product <= a_mantissa * b_mantissa;
            z_exponent <= a_exponent + b_exponent - 10'd127;
            z_sign <= a_sign ^ b_sign;
            
            // Extract rounding bits
            guard_bit <= product[22];
            round_bit <= product[21];
            sticky <= |product[20:0];
        end
    end

    // Stage 2: Normalization and rounding
    always @(posedge clk) begin
        if (counter == 2) begin
            // Normalization
            if (product[47]) begin
                z_mantissa <= product[46:23];
                z_exponent <= z_exponent + 1;
            end else begin
                z_mantissa <= product[45:22];
            end
            
            // Rounding (round to nearest even)
            if (guard_bit && (round_bit || sticky || z_mantissa[0])) begin
                z_mantissa <= z_mantissa + 1;
                if (&z_mantissa) begin // Handle mantissa overflow
                    z_exponent <= z_exponent + 1;
                end
            end
        end
    end

    // Stage 3: Output assembly and special cases
    always @(posedge clk) begin
        if (counter == 3) begin
            // Check for NaN
            if ((a_exponent[7:0] == 8'hFF && a_mantissa[22:0] != 0) ||
                (b_exponent[7:0] == 8'hFF && b_mantissa[22:0] != 0)) begin
                z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
            end
            // Check for 0 * inf
            else if (((a_exponent[7:0] == 0 && a_mantissa[22:0] == 0) && 
                     (b_exponent[7:0] == 8'hFF && b_mantissa[22:0] == 0)) ||
                    ((b_exponent[7:0] == 0 && b_mantissa[22:0] == 0) && 
                     (a_exponent[7:0] == 8'hFF && a_mantissa[22:0] == 0))) begin
                z <= {1'b0, 8'hFF, 23'h7FFFFF}; // NaN
            end
            // Check for infinity
            else if ((a_exponent[7:0] == 8'hFF && a_mantissa[22:0] == 0) ||
                    (b_exponent[7:0] == 8'hFF && b_mantissa[22:0] == 0)) begin
                z <= {z_sign, 8'hFF, 23'h0}; // Infinity
            end
            // Check for zero
            else if ((a_exponent[7:0] == 0 && a_mantissa[22:0] == 0) ||
                    (b_exponent[7:0] == 0 && b_mantissa[22:0] == 0)) begin
                z <= {z_sign, 31'h0}; // Zero
            end
            // Check for overflow
            else if (z_exponent >= 10'h0FF) begin
                z <= {z_sign, 8'hFF, 23'h0}; // Infinity
            end
            // Check for underflow
            else if (z_exponent == 0) begin
                z <= {z_sign, 31'h0}; // Zero
            end
            // Normal case
            else begin
                z <= {z_sign, z_exponent[7:0], z_mantissa[22:0]};
            end
        end
    end

endmodule