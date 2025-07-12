module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Split mantissa parameters
    localparam HALF_WIDTH = 12;
    localparam FULL_WIDTH = 24;
    
    // Pipeline control
    reg [1:0] state;
    localparam S_EXTRACT = 0;
    localparam S_MULTIPLY = 1;
    localparam S_ROUND = 2;
    localparam S_OUTPUT = 3;
    
    // Input decomposition
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [FULL_WIDTH-1:0] a_man, b_man;
    
    // Partial products
    reg [HALF_WIDTH-1:0] a1, a0, b1, b0;
    reg [2*HALF_WIDTH-1:0] p0, p1, p2, p3;
    
    // Intermediate results
    reg [2*FULL_WIDTH-1:0] product;
    reg [FULL_WIDTH:0] sum_upper;
    reg [FULL_WIDTH-1:0] sum_lower;
    reg [7:0] exp_sum;
    reg sign;
    
    // Normalization prediction
    reg [1:0] shift_pred;
    reg [7:0] exp_adj [0:3];
    reg [FULL_WIDTH-1:0] man_shifted [0:3];
    
    // Rounding
    reg guard, round, sticky;
    reg round_inc;
    
    // Special cases
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Leading zero prediction
    function [1:0] predict_shift;
        input [2*FULL_WIDTH-1:0] p;
        begin
            if (p[47]) predict_shift = 0;
            else if (p[46]) predict_shift = 1;
            else predict_shift = 2;
        end
    endfunction
    
    // Partial product generation
    always @(posedge clk) begin
        if (rst) begin
            state <= S_EXTRACT;
            z <= 0;
        end else begin
            case (state)
                S_EXTRACT: begin
                    // Decompose inputs
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    
                    // Handle denormals
                    a_man <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_man <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Split mantissas
                    a1 <= a_man[FULL_WIDTH-1:HALF_WIDTH];
                    a0 <= a_man[HALF_WIDTH-1:0];
                    b1 <= b_man[FULL_WIDTH-1:HALF_WIDTH];
                    b0 <= b_man[HALF_WIDTH-1:0];
                    
                    state <= S_MULTIPLY;
                end
                
                S_MULTIPLY: begin
                    // Generate partial products
                    p0 <= a0 * b0;
                    p1 <= a0 * b1;
                    p2 <= a1 * b0;
                    p3 <= a1 * b1;
                    
                    // Calculate exponent sum
                    exp_sum <= a_exp + b_exp - 8'd126; // -127 +1 for implicit bit
                    sign <= a_sign ^ b_sign;
                    
                    state <= S_ROUND;
                end
                
                S_ROUND: begin
                    // Combine partial products
                    sum_lower <= p0[HALF_WIDTH-1:0];
                    sum_upper <= {p3, {HALF_WIDTH{1'b0}}} + 
                                {{HALF_WIDTH{1'b0}}, p2, {HALF_WIDTH{1'b0}}} + 
                                {{HALF_WIDTH{1'b0}}, p1, {HALF_WIDTH{1'b0}}} + 
                                {{2*HALF_WIDTH{1'b0}}, p0[2*HALF_WIDTH-1:HALF_WIDTH]};
                    
                    // Form full product
                    product <= {sum_upper, sum_lower};
                    
                    // Predict normalization shift
                    shift_pred <= predict_shift({sum_upper, sum_lower});
                    
                    // Pre-calculate all possible shifts
                    man_shifted[0] <= product[47:24];
                    man_shifted[1] <= product[46:23];
                    man_shifted[2] <= product[45:22];
                    
                    // Pre-calculate exponent adjustments
                    exp_adj[0] <= exp_sum;
                    exp_adj[1] <= exp_sum + 1;
                    exp_adj[2] <= exp_sum + 2;
                    
                    // Pre-compute rounding bits
                    guard <= product[23];
                    round <= product[22];
                    sticky <= |product[21:0];
                    
                    state <= S_OUTPUT;
                end
                
                S_OUTPUT: begin
                    // Apply normalization
                    z[22:0] <= man_shifted[shift_pred][22:0];
                    z[30:23] <= exp_adj[shift_pred];
                    z[31] <= sign;
                    
                    // Apply rounding (hybrid scheme)
                    round_inc <= guard && (round || sticky || man_shifted[shift_pred][0]);
                    if (round_inc) begin
                        z[22:0] <= z[22:0] + 1;
                        if (&z[22:0]) begin // Handle overflow
                            z[22:0] <= 0;
                            z[30:23] <= z[30:23] + 1;
                        end
                    end
                    
                    // Handle special cases
                    if (a_nan || b_nan) z <= 32'h7FC00000;
                    else if ((a_inf && b_zero) || (b_inf && a_zero)) z <= 32'h7FC00000;
                    else if (a_inf || b_inf) z <= {sign, 8'hFF, 23'b0};
                    else if (a_zero || b_zero) z <= {sign, 31'b0};
                    else if (exp_adj[shift_pred] > 8'hFD) z <= {sign, 8'hFF, 23'b0}; // Overflow
                    else if (exp_adj[shift_pred] == 0) z <= {sign, 31'b0}; // Underflow
                    
                    state <= S_EXTRACT;
                end
            endcase
        end
    end

endmodule