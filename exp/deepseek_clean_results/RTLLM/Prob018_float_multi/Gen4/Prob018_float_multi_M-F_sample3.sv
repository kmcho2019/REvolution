module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg [31:0] a_reg, b_reg;
    reg a_sign, b_sign, z_sign;
    reg [7:0] a_exp, b_exp, z_exp;
    reg [23:0] a_man, b_man, z_man;
    reg [47:0] product;
    reg [7:0] exp_sum;
    reg special_case;

    // Wallace Tree temporary variables
    reg [47:0] pp [0:23];
    reg [47:0] sum1, carry1;
    reg [47:0] sum2, carry2;
    reg [47:0] sum3, carry3;
    reg [47:0] sum4, carry4;

    // Special case flags
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Wallace Tree implementation - combinational logic
    always @(*) begin
        // Generate partial products
        for (integer i = 0; i < 24; i = i + 1) begin
            pp[i] = b_man[i] ? (a_man << i) : 48'b0;
        end

        // First level CSA (3:2 compression)
        sum1 = pp[0] ^ pp[1] ^ pp[2];
        carry1 = ((pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2])) << 1;

        // Second level CSA
        sum2 = sum1 ^ carry1 ^ pp[3];
        carry2 = ((sum1 & carry1) | (sum1 & pp[3]) | (carry1 & pp[3])) << 1;

        // Third level CSA
        sum3 = sum2 ^ carry2 ^ pp[4];
        carry3 = ((sum2 & carry2) | (sum2 & pp[4]) | (carry2 & pp[4])) << 1;

        // Final addition
        product = sum3 + carry3;
    end

    // Rounding function
    function [30:0] rounder;
        input [47:0] product;
        input [7:0] exp_in;
        reg guard, round, sticky;
        begin
            guard = product[22];
            round = product[21];
            sticky = |product[20:0];
            
            if (guard && (round || sticky || product[23])) begin
                rounder = {exp_in + (&product[46:24]), product[46:24] + 1};
            end else begin
                rounder = {exp_in, product[46:24]};
            end
        end
    endfunction

    // Normalization function
    function [30:0] normalize;
        input [47:0] product;
        input [7:0] exp_in;
        reg [4:0] shift_amount;
        begin
            if (product[47]) begin
                normalize = {exp_in + 1, product[46:24]};
            end else begin
                shift_amount = 0;
                while (~product[46-shift_amount] && (shift_amount < 24)) begin
                    shift_amount = shift_amount + 1;
                end
                normalize = {exp_in - shift_amount, product[46-shift_amount:24-shift_amount]};
            end
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input and special case detection
                    a_reg <= a;
                    b_reg <= b;
                    special_case <= any_nan || inf_times_zero || a_is_inf || b_is_inf || a_is_zero || b_is_zero;
                    
                    if (~special_case) begin
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        exp_sum <= a[30:23] + b[30:23] - 8'd127;
                    end
                    stage <= 1;
                end
                
                1: begin // Stage 1: Multiplication
                    if (special_case) begin
                        if (any_nan || inf_times_zero) begin
                            z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                        end else if (a_is_inf || b_is_inf) begin
                            z <= {a_sign ^ b_sign, 8'hFF, 23'h0}; // Inf
                        end else begin // Zero
                            z <= {a_sign ^ b_sign, 31'h0};
                        end
                        stage <= 0;
                    end else begin
                        z_sign <= a_sign ^ b_sign;
                        stage <= 2;
                    end
                end
                
                2: begin // Stage 2: Normalization and rounding
                    if (~special_case) begin
                        {z_exp, z_man} = normalize(product, exp_sum);
                        {z_man, z_exp} = rounder({z_man, product[23:0]}, z_exp);
                        
                        // Handle overflow/underflow
                        if (z_exp[7] || (&z_exp)) begin // Underflow or overflow
                            z <= z_exp[7] ? {z_sign, 31'h0} : {z_sign, 8'hFF, 23'h0};
                        end else begin
                            z <= {z_sign, z_exp, z_man[22:0]};
                        end
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule