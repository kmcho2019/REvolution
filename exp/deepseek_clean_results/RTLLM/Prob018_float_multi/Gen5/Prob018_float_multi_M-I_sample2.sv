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

    // Special case flags
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);

    // Wallace Tree implementation
    wire [47:0] pp [0:23];
    wire [47:0] sum1, carry1;
    wire [47:0] sum2, carry2;
    wire [47:0] sum3, carry3;
    wire [47:0] final_sum;

    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 24; i = i + 1) begin : pp_gen
            assign pp[i] = b_man[i] ? (a_man << i) : 48'b0;
        end
    endgenerate

    // CSA stages
    assign sum1 = pp[0] ^ pp[1] ^ pp[2];
    assign carry1 = ((pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2])) << 1;

    assign sum2 = sum1 ^ carry1 ^ pp[3];
    assign carry2 = ((sum1 & carry1) | (sum1 & pp[3]) | (carry1 & pp[3])) << 1;

    assign sum3 = sum2 ^ carry2 ^ pp[4];
    assign carry3 = ((sum2 & carry2) | (sum2 & pp[4]) | (carry2 & pp[4])) << 1;

    // Final addition
    assign final_sum = sum3 + carry3;

    // Rounding and normalization logic
    function [30:0] round_and_normalize;
        input [47:0] prod;
        input [7:0] exp_in;
        reg [47:0] shifted_prod;
        reg [4:0] shift_count;
        reg guard, round, sticky;
        begin
            // Normalization
            if (prod[47]) begin
                shifted_prod = prod >> 1;
                round_and_normalize = {exp_in + 8'd1, shifted_prod[46:24]};
            end else begin
                shift_count = 0;
                while (~prod[46-shift_count] && shift_count < 23) begin
                    shift_count = shift_count + 1;
                end
                shifted_prod = prod << shift_count;
                round_and_normalize = {exp_in - {3'b0, shift_count}, shifted_prod[46:24]};
            end

            // Rounding
            guard = round_and_normalize[22];
            round = round_and_normalize[21];
            sticky = |shifted_prod[20:0];
            if (guard && (round || sticky || round_and_normalize[23])) begin
                round_and_normalize[23:0] = round_and_normalize[23:0] + 24'd1;
                if (&round_and_normalize[23:0]) begin // Overflow in mantissa
                    round_and_normalize[30:23] = round_and_normalize[30:23] + 8'd1;
                    round_and_normalize[22:0] = 23'b0;
                end
            end
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            case (stage)
                0: begin // Stage 0: Input processing
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
                        product <= final_sum;
                        z_sign <= a_sign ^ b_sign;
                        stage <= 2;
                    end
                end
                
                2: begin // Stage 2: Normalization and rounding
                    {z_exp, z_man} = round_and_normalize(product, exp_sum);
                    
                    // Handle overflow/underflow
                    if (z_exp[7] || (&z_exp)) begin
                        z <= z_exp[7] ? {z_sign, 31'h0} : {z_sign, 8'hFF, 23'h0};
                    end else begin
                        z <= {z_sign, z_exp, z_man[22:0]};
                    end
                    stage <= 0;
                end
            endcase
        end
    end

endmodule