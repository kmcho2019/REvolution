module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam S_SPLIT = 0;
    localparam S_PRODUCT = 1;
    localparam S_OUTPUT = 2;

    reg [1:0] state;
    
    // Split mantissa components
    reg [11:0] a_hi, a_lo, b_hi, b_lo;
    reg [8:0] a_exp, b_exp, z_exp;
    reg a_sig, b_sig, z_sig;
    
    // Partial products
    reg [23:0] pp_hi_hi, pp_hi_lo, pp_lo_hi, pp_lo_lo;
    
    // Summation components
    reg [47:0] sum_stage1;
    reg [23:0] sum_stage2;
    reg [23:0] final_mantissa;
    
    // Early normalization info
    reg norm_shift;
    reg [4:0] leading_zeros;
    
    // Parallel rounding path
    reg guard, round, sticky;
    
    // Special case detection
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Exponent calculation
    wire [8:0] exp_sum = {1'b0, a[30:23]} + {1'b0, b[30:23]} - 9'd127;
    wire [8:0] adj_exp = exp_sum + norm_shift - leading_zeros;
    
    // Rounding decision
    wire round_up = guard & (round | sticky | final_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sig, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sig, 31'b0};
    wire [31:0] normal_out = {z_sig, adj_exp[7:0], final_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_SPLIT;
            z <= 0;
        end else begin
            case (state)
                S_SPLIT: begin
                    // Split inputs
                    a_sig <= a[31];
                    b_sig <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    
                    // Split mantissas with implicit bit handling
                    a_hi <= (|a[30:23]) ? a[22:11] : {1'b1, a[21:11]};
                    a_lo <= (|a[30:23]) ? {1'b0, a[10:0]} : {1'b0, a[10:0]};
                    b_hi <= (|b[30:23]) ? b[22:11] : {1'b1, b[21:11]};
                    b_lo <= (|b[30:23]) ? {1'b0, b[10:0]} : {1'b0, b[10:0]};
                    
                    state <= S_PRODUCT;
                end
                
                S_PRODUCT: begin
                    // Compute partial products in parallel
                    pp_hi_hi <= a_hi * b_hi;
                    pp_hi_lo <= a_hi * b_lo;
                    pp_lo_hi <= a_lo * b_hi;
                    pp_lo_lo <= a_lo * b_lo;
                    
                    // First stage summation
                    sum_stage1 <= (pp_hi_hi << 24) + (pp_hi_lo << 12) + 
                                 (pp_lo_hi << 12) + pp_lo_lo;
                    
                    // Early normalization detection
                    norm_shift <= sum_stage1[47];
                    leading_zeros <= count_leading_zeros(sum_stage1[46:23]);
                    
                    // Parallel rounding path
                    guard <= sum_stage1[22];
                    round <= sum_stage1[21];
                    sticky <= |sum_stage1[20:0];
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Final normalization and rounding
                    final_mantissa <= norm_shift ? 
                                     (sum_stage1[47:24] + round_up) : 
                                     (sum_stage1[46:23] + round_up);
                    
                    z_sig <= a_sig ^ b_sig;
                    
                    // Handle special cases with priority
                    if (a_nan || b_nan) begin
                        z <= nan_out;
                    end
                    else if ((a_inf || b_inf) && (a_zero || b_zero)) begin
                        z <= nan_out;
                    end
                    else if (a_inf || b_inf) begin
                        z <= inf_out;
                    end
                    else if (a_zero || b_zero) begin
                        z <= zero_out;
                    end
                    else if (adj_exp[8] || &adj_exp[7:0]) begin // Overflow
                        z <= inf_out;
                    end
                    else if (adj_exp == 0) begin // Underflow
                        z <= zero_out;
                    end
                    else begin
                        z <= normal_out;
                    end
                    
                    state <= S_SPLIT;
                end
            endcase
        end
    end
    
    // Helper function to count leading zeros
    function [4:0] count_leading_zeros;
        input [23:0] val;
        begin
            count_leading_zeros = 24;
            if (val[23]) count_leading_zeros = 0;
            else if (val[22]) count_leading_zeros = 1;
            else if (val[21]) count_leading_zeros = 2;
            // ... continue for all bits ...
            else if (val[0]) count_leading_zeros = 23;
        end
    endfunction

endmodule