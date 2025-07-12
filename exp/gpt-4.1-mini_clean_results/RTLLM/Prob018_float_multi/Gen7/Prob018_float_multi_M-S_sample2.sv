module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    reg [1:0] counter;

    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    reg [9:0] exp_sum;

    reg [49:0] product;

    reg sign_res;
    reg [9:0] exp_res;
    reg [23:0] man_res;

    // Special cases flags
    reg a_zero, b_zero;
    reg a_inf, b_inf;
    reg a_nan, b_nan;

    // Rounding bits
    reg guard, round_bit, sticky;

    localparam EXP_BIAS = 127;

    // Extract fields on cycle 0
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'd0;
            z <= 32'd0;
            a_sign <= 0; b_sign <= 0;
            a_exp <= 0; b_exp <= 0;
            a_man <= 0; b_man <= 0;
            product <= 0;
            sign_res <= 0;
            exp_sum <= 0;
            exp_res <= 0;
            man_res <= 0;
            a_zero <= 0; b_zero <= 0;
            a_inf <= 0; b_inf <= 0;
            a_nan <= 0; b_nan <= 0;
            guard <= 0; round_bit <= 0; sticky <= 0;
        end else begin
            case(counter)
                2'd0: begin
                    // Extract sign
                    a_sign <= a[31]; b_sign <= b[31];
                    // Extract exponent
                    a_exp <= a[30:23]; b_exp <= b[30:23];
                    // Extract mantissa and add implicit leading 1 for normalized
                    a_man <= (a[30:23]==8'd0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
                    b_man <= (b[30:23]==8'd0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
                    // Special cases
                    a_zero <= (a[30:23]==8'd0) && (a[22:0]==0);
                    b_zero <= (b[30:23]==8'd0) && (b[22:0]==0);
                    a_inf <= (a[30:23]==8'hFF) && (a[22:0]==0);
                    b_inf <= (b[30:23]==8'hFF) && (b[22:0]==0);
                    a_nan <= (a[30:23]==8'hFF) && (a[22:0]!=0);
                    b_nan <= (b[30:23]==8'hFF) && (b[22:0]!=0);
                    // Calculate sign of result
                    sign_res <= a[31] ^ b[31];
                    // Sum exponent - bias (using 10 bits for overflow)
                    exp_sum <= a_exp + b_exp - EXP_BIAS;
                    counter <= 2'd1;
                end
                2'd1: begin
                    // Multiply mantissas (24x24->48 bits)
                    product <= a_man * b_man;
                    counter <= 2'd2;
                end
                2'd2: begin
                    // Normalize product
                    if (product[47]) begin
                        // Leading 1 at bit 47 means shift right 1 and increment exponent
                        man_res <= product[46:23];
                        exp_res <= exp_sum + 1;
                        // Extract rounding bits
                        guard <= product[23];
                        round_bit <= product[22];
                        sticky <= |product[21:0];
                    end else begin
                        man_res <= product[45:22];
                        exp_res <= exp_sum;
                        guard <= product[22];
                        round_bit <= product[21];
                        sticky <= |product[20:0];
                    end
                    // Round to nearest even
                    if (guard && (round_bit || sticky || man_res[0])) begin
                        {exp_res, man_res} = {exp_res, man_res} + 25'd1;
                        // After rounding, handle mantissa overflow
                        if (man_res == 24'h1000000) begin
                            man_res <= 24'h800000;
                            exp_res <= exp_res + 1;
                        end
                    end

                    // Handle special cases and exceptions
                    if (a_nan || b_nan) begin
                        // Output quiet NaN: sign=0, exp=all 1s, MSB mantissa=1
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                        // Inf * 0 = NaN
                        z <= {1'b0, 8'hFF, 1'b1, 22'd0};
                    end else if (a_inf || b_inf) begin
                        // Inf times nonzero = Inf
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (a_zero || b_zero) begin
                        // Zero times anything = zero
                        z <= {sign_res, 31'd0};
                    end else if (exp_res >= 8'hFF) begin
                        // Overflow to Inf
                        z <= {sign_res, 8'hFF, 23'd0};
                    end else if (exp_res <= 0) begin
                        // Underflow to zero (no gradual underflow handling)
                        z <= {sign_res, 31'd0};
                    end else begin
                        // Normalized number
                        z <= {sign_res, exp_res[7:0], man_res[22:0]};
                    end

                    counter <= 2'd0;
                end
            endcase
        end
    end

endmodule