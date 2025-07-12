module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [31:0] stage1_z;
    reg stage1_sign;
    reg [7:0] stage1_exp;
    reg [23:0] stage1_man;
    reg stage1_special;
    reg stage1_nan, stage1_inf, stage1_zero;

    // Internal signals
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man, z_man;
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg [5:0] leading_zeros;
    reg guard, round, sticky;
    reg special_case, result_nan, result_inf, result_zero;

    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_denorm = (a[30:23] == 0) & (a[22:0] != 0);
    wire b_denorm = (b[30:23] == 0) & (b[22:0] != 0);
    wire a_inf = (a[30:23] == 8'hFF) & (a[22:0] == 0);
    wire b_inf = (b[30:23] == 8'hFF) & (b[22:0] == 0);
    wire a_nan = (a[30:23] == 8'hFF) & (a[22:0] != 0);
    wire b_nan = (b[30:23] == 8'hFF) & (b[22:0] != 0);

    // Booth-encoded multiplier
    function [47:0] booth_mult;
        input [23:0] a, b;
        reg [47:0] pp [0:11];
        reg [47:0] sum;
        integer i;
    begin
        // Generate partial products
        for (i = 0; i < 12; i = i+1) begin
            case (b[2*i+1:2*i-1])
                3'b000, 3'b111: pp[i] = 0;
                3'b001, 3'b010: pp[i] = a << (2*i);
                3'b011:         pp[i] = (a << (2*i)) << 1;
                3'b100:         pp[i] = ~((a << (2*i)) << 1) + 1;
                3'b101, 3'b110: pp[i] = ~(a << (2*i)) + 1;
            endcase
        end

        // Sum partial products
        sum = pp[0] + pp[1] + pp[2] + pp[3] + pp[4] + pp[5] +
              pp[6] + pp[7] + pp[8] + pp[9] + pp[10] + pp[11];
        booth_mult = sum;
    end
    endfunction

    // Priority encoder for leading zeros
    function [5:0] count_leading_zeros;
        input [47:0] val;
        integer i;
    begin
        count_leading_zeros = 48;
        for (i = 47; i >= 0; i = i-1) begin
            if (val[i]) begin
                count_leading_zeros = 47 - i;
                i = -1; // exit loop
            end
        end
    end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
            stage1_z <= 0;
            stage1_sign <= 0;
            stage1_exp <= 0;
            stage1_man <= 0;
            stage1_special <= 0;
            stage1_nan <= 0;
            stage1_inf <= 0;
            stage1_zero <= 0;
        end else begin
            // Stage 1: Extract components and special cases
            a_sign <= a[31];
            b_sign <= b[31];
            a_exp <= a[30:23];
            b_exp <= b[30:23];
            a_man <= (a_exp == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_man <= (b_exp == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};

            result_nan <= a_nan | b_nan | (a_zero & b_inf) | (a_inf & b_zero);
            result_inf <= (a_inf | b_inf) & ~result_nan;
            result_zero <= (a_zero | b_zero) & ~result_nan;
            special_case <= result_nan | result_inf | result_zero;

            // Stage 1: Multiply mantissas and calculate exponent
            if (!special_case) begin
                product <= booth_mult(a_man, b_man);
                exp_sum <= (a_denorm ? 8'd1 : a_exp) + (b_denorm ? 8'd1 : b_exp) - 127;
            end

            // Stage 2: Normalization and rounding
            if (stage1_special) begin
                if (stage1_nan) begin
                    z <= {1'b0, 8'hFF, 23'h7FFFFF}; // Canonical NaN
                end else if (stage1_inf) begin
                    z <= {stage1_sign, 8'hFF, 23'h0};
                end else begin // zero
                    z <= {stage1_sign, 31'h0};
                end
            end else begin
                // Normalization
                leading_zeros <= count_leading_zeros(product);
                if (product[47]) begin
                    z_man <= product[46:23];
                    z_exp <= exp_sum + 1;
                end else begin
                    z_man <= product[45:22] << (leading_zeros + 1);
                    z_exp <= exp_sum - leading_zeros;
                end

                // Rounding bits
                guard <= product[22];
                round <= product[21];
                sticky <= |product[20:0];

                // Round to nearest even
                if (guard && (round || sticky || z_man[0])) begin
                    {z_exp, z_man} <= z_man + 1;
                    if (z_man == 24'hFFFFFF) begin
                        z_man <= 24'h800000;
                        z_exp <= z_exp + 1;
                    end
                end

                // Final overflow/underflow check
                if (z_exp > 254) begin
                    z <= {stage1_sign, 8'hFF, 23'h0}; // Infinity
                end else if (z_exp < 1) begin
                    z <= {stage1_sign, 31'h0}; // Zero
                end else begin
                    z <= {stage1_sign, z_exp, z_man[22:0]};
                end
            end

            // Pipeline registers update
            stage1_sign <= a_sign ^ b_sign;
            stage1_special <= special_case;
            stage1_nan <= result_nan;
            stage1_inf <= result_inf;
            stage1_zero <= result_zero;
        end
    end

endmodule