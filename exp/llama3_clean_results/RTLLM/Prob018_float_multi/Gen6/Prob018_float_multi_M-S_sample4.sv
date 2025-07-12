module float_multi(clk, rst, a, b, z);
    input clk, rst;
    input [31:0] a, b;
    output reg [31:0] z;

    // Internal signals
    reg [23:0] a_mantissa, b_mantissa;
    reg [8:0] a_exponent, b_exponent;
    reg a_sign, b_sign;
    reg [47:0] product;
    reg [2:0] counter;

    // Input Processing
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
        end
    end

    // Fixed-Point Multiplier
    always @(posedge clk) begin
        if (rst) begin
            product <= 0;
        end else begin
            product <= {1'b1, a_mantissa} * {1'b1, b_mantissa};
        end
    end

    // Special Cases Handling
    always @(posedge clk) begin
        if (rst) begin
            z <= 0;
        end else if ((a_exponent == 9'h1ff && a_mantissa!= 0) || (b_exponent == 9'h1ff && b_mantissa!= 0)) begin
            // NaN
            z <= 32'h7fc00000;
        end else if ((a_exponent == 9'h1ff && a_mantissa == 0) || (b_exponent == 9'h1ff && b_mantissa == 0)) begin
            // Infinity
            if (a_sign == b_sign) begin
                z <= {1'b1, 8'h7f, 23'd0}; // +Inf
            end else begin
                z <= {1'b0, 8'h7f, 23'd0}; // -Inf
            end
        end else begin
            // Normal cases
            if (counter == 0) begin
                // Start of operation
                counter <= counter + 1;
            end else if (counter == 1) begin
                // Rounding and exponent adjustment
                z[22:0] <= product[47:24];
                z[30:23] <= a_exponent + b_exponent - 9'h7f;
                z[31] <= a_sign ^ b_sign;
                counter <= counter + 1;
            end else begin
                // Reset counter
                counter <= 0;
            end
        end
    end

    // State Machine
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
        end else begin
            // No change needed
        end
    end
endmodule