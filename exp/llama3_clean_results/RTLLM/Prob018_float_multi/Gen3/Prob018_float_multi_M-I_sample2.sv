module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    reg [22:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [49:0] product;
    reg [2:0] counter; // Counter for pipelining

    // State Machine
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // Input Processing and Special Cases Handling
    always @(posedge clk) begin
        if (counter == 1) begin
            // Extract mantissa, exponent, and sign from inputs
            a_mantissa <= a[22:0];
            a_exponent <= a[30:23];
            a_sign <= a[31];
            b_mantissa <= b[22:0];
            b_exponent <= b[30:23];
            b_sign <= b[31];

            // Special cases handling
            if ((a_exponent == 8'hff && a_mantissa != 0) || (b_exponent == 8'hff && b_mantissa != 0)) begin
                // NaN handling
                z <= 32'h7fc00000;
            end else if (a_exponent == 8'hff && a_mantissa == 0) begin
                if (a_sign == b_sign) begin
                    z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                end else begin
                    z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                end
            end else if (b_exponent == 8'hff && b_mantissa == 0) begin
                if (a_sign == b_sign) begin
                    z <= {1'b1, 8'h7f, 23'd0}; // +Inf
                end else begin
                    z <= {1'b0, 8'h7f, 23'd0}; // -Inf
                end
            end
        end
    end

    // Multiplication and Exponent Adjustment
    always @(posedge clk) begin
        if (counter == 2) begin
            // Perform mantissa multiplication and adjust exponent
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
            z_exponent <= a_exponent + b_exponent - 127;
            z_sign <= a_sign ^ b_sign;
        end
    end

    // Rounding, Normalization, and Output Generation
    always @(posedge clk) begin
        if (counter == 3) begin
            // Rounding logic
            if (product[23] && (product[22] || |product[21:0])) begin
                z_mantissa <= product[47:24] + 1;
                if (z_mantissa == 24'h1000000) begin
                    z_exponent <= z_exponent + 1;
                    z_mantissa <= 0;
                end
            end else begin
                z_mantissa <= product[47:24];
            end

            // Overflow and underflow handling
            if (z_exponent > 255) begin
                z <= {1'b1, 8'h7f, 23'd0}; // +Inf
            end else if (z_exponent < 1) begin
                z <= {1'b0, 8'h0, 23'd0}; // 0
            end else begin
                z <= {z_sign, z_exponent, z_mantissa};
            end
        end
    end
endmodule