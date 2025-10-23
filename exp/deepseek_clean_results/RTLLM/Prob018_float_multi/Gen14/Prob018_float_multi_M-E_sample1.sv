module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg a_sign_pipe[0:2], b_sign_pipe[0:2];
    reg [7:0] a_exp_pipe[0:2], b_exp_pipe[0:2];
    reg [23:0] a_man_pipe[0:2], b_man_pipe[0:2];
    reg special_case_pipe[0:2];
    reg is_nan_pipe[0:2], is_inf_pipe[0:2], is_zero_pipe[0:2];
    
    // Internal signals
    wire a_sign = a[31];
    wire b_sign = b[31];
    wire [7:0] a_exp = a[30:23];
    wire [7:0] b_exp = b[30:23];
    wire [23:0] a_man = (a_exp != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
    wire [23:0] b_man = (b_exp != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
    
    // Special case detection (combinational)
    wire is_nan = (a_exp == 8'hFF && |a[22:0]) || (b_exp == 8'hFF && |b[22:0]);
    wire is_inf = (a_exp == 8'hFF && ~|a[22:0]) || (b_exp == 8'hFF && ~|b[22:0]);
    wire is_zero = (a_exp == 0 && ~|a[22:0]) || (b_exp == 0 && ~|b[22:0]);
    wire special_case = is_nan | is_inf | is_zero;
    
    // Wallace tree partial products (stage 0)
    wire [47:0] pp [23:0];
    generate
        for (genvar i = 0; i < 24; i = i + 1) begin
            assign pp[i] = b_man[i] ? (a_man << i) : 48'b0;
        end
    endgenerate
    
    // Carry-save reduction (stage 1)
    wire [47:0] sum1, carry1;
    carry_save_reduce csr1 (
        .pp0(pp[0]), .pp1(pp[1]), .pp2(pp[2]), .pp3(pp[3]),
        .pp4(pp[4]), .pp5(pp[5]), .pp6(pp[6]), .pp7(pp[7]),
        .sum(sum1), .carry(carry1)
    );
    
    // Final addition (stage 2)
    wire [47:0] product = sum1 + (carry1 << 1);
    
    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a_exp} + {1'b0, b_exp} - 9'd127;
    wire norm_bit = product[47];
    wire [8:0] exp_adj = exp_sum + norm_bit;
    wire exp_overflow = exp_adj[8] | (&exp_adj[7:0]);
    wire exp_underflow = (exp_adj < 9'd1);
    
    // Rounding logic
    wire guard = product[22];
    wire round = product[21];
    wire sticky = |product[20:0];
    wire round_up = guard & (round | sticky | product[23]);
    wire [22:0] rounded_man = product[46:24] + round_up;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            z <= 0;
        end else begin
            // Pipeline stage 0
            a_sign_pipe[0] <= a_sign;
            b_sign_pipe[0] <= b_sign;
            a_exp_pipe[0] <= a_exp;
            b_exp_pipe[0] <= b_exp;
            a_man_pipe[0] <= a_man;
            b_man_pipe[0] <= b_man;
            special_case_pipe[0] <= special_case;
            is_nan_pipe[0] <= is_nan;
            is_inf_pipe[0] <= is_inf;
            is_zero_pipe[0] <= is_zero;
            
            // Pipeline stage 1
            a_sign_pipe[1] <= a_sign_pipe[0];
            b_sign_pipe[1] <= b_sign_pipe[0];
            a_exp_pipe[1] <= a_exp_pipe[0];
            b_exp_pipe[1] <= b_exp_pipe[0];
            special_case_pipe[1] <= special_case_pipe[0];
            is_nan_pipe[1] <= is_nan_pipe[0];
            is_inf_pipe[1] <= is_inf_pipe[0];
            is_zero_pipe[1] <= is_zero_pipe[0];
            
            // Pipeline stage 2
            a_sign_pipe[2] <= a_sign_pipe[1];
            b_sign_pipe[2] <= b_sign_pipe[1];
            special_case_pipe[2] <= special_case_pipe[1];
            is_nan_pipe[2] <= is_nan_pipe[1];
            is_inf_pipe[2] <= is_inf_pipe[1];
            is_zero_pipe[2] <= is_zero_pipe[1];
            
            // Output generation
            if (is_nan_pipe[2]) begin
                z <= 32'h7FC00000; // NaN
            end else if (is_inf_pipe[2]) begin
                z <= {a_sign_pipe[2] ^ b_sign_pipe[2], 8'hFF, 23'b0}; // Infinity
            end else if (is_zero_pipe[2]) begin
                z <= {a_sign_pipe[2] ^ b_sign_pipe[2], 31'b0}; // Zero
            end else if (exp_overflow) begin
                z <= {a_sign_pipe[2] ^ b_sign_pipe[2], 8'hFF, 23'b0}; // Overflow
            end else if (exp_underflow) begin
                z <= {a_sign_pipe[2] ^ b_sign_pipe[2], 31'b0}; // Underflow
            end else begin
                z <= {a_sign_pipe[2] ^ b_sign_pipe[2], exp_adj[7:0], rounded_man};
            end
        end
    end

endmodule

module carry_save_reduce(
    input [47:0] pp0, pp1, pp2, pp3,
    input [47:0] pp4, pp5, pp6, pp7,
    output [47:0] sum,
    output [47:0] carry
);
    // First level of carry-save addition
    wire [47:0] sum_a, carry_a;
    csa #(48) csa1(pp0, pp1, pp2, sum_a, carry_a);
    
    wire [47:0] sum_b, carry_b;
    csa #(48) csa2(pp3, pp4, pp5, sum_b, carry_b);
    
    // Second level of carry-save addition
    wire [47:0] sum_c, carry_c;
    csa #(48) csa3(sum_a, carry_a << 1, sum_b, sum_c, carry_c);
    
    // Final addition
    assign sum = sum_c;
    assign carry = (carry_b << 1) + (carry_c << 2);
endmodule

module csa #(parameter WIDTH=48) (
    input [WIDTH-1:0] a, b, c,
    output [WIDTH-1:0] sum, carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule