module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // State encoding
    localparam EXTRACT = 0;
    localparam MULT1 = 1;
    localparam MULT2 = 2;
    localparam NORM = 3;
    localparam ROUND = 4;
    localparam OUTPUT = 5;

    reg [2:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [23:0] partial_hi, partial_lo;
    reg [47:0] product;
    reg guard_bit, round_bit, sticky;
    reg overflow_flag;
    
    // Encoded special cases
    reg [1:0] special_case;
    localparam NONE = 0;
    localparam INF = 1;
    localparam ZERO = 2;
    localparam NAN = 3;
    
    // Combinational signals
    wire [7:0] exp_sum = a_exponent + b_exponent;
    wire [7:0] exp_biased = exp_sum - 8'd127;
    wire sign_result = a_sign ^ b_sign;
    wire [23:0] norm_mantissa = product[47] ? product[47:24] : product[46:23];
    wire [7:0] norm_exponent = product[47] ? (exp_biased + 1) : exp_biased;
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent, z_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
            special_case <= NONE;
        end else begin
            case (state)
                EXTRACT: begin
                    // Extract components
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exponent <= a[30:23];
                    b_exponent <= b[30:23];
                    a_mantissa <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_mantissa <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Gated special case detection
                    if ((&a[30:23]) begin
                        special_case <= (|a[22:0]) ? NAN : INF;
                    end else if ((&b[30:23])) begin
                        special_case <= (|b[22:0]) ? NAN : INF;
                    end else if (a[30:0] == 0 || b[30:0] == 0) begin
                        special_case <= ZERO;
                    end else begin
                        special_case <= NONE;
                    end
                    
                    state <= MULT1;
                end
                
                MULT1: begin
                    // First partial product (24x12)
                    partial_hi <= a_mantissa * b_mantissa[23:12];
                    partial_lo <= a_mantissa * b_mantissa[11:0];
                    
                    // Early sticky calculation (lower 12 bits)
                    sticky <= |b_mantissa[11:0];
                    
                    state <= MULT2;
                end
                
                MULT2: begin
                    // Combine partial products
                    product <= (partial_hi << 12) + partial_lo;
                    z_exponent <= exp_biased;
                    z_sign <= sign_result;
                    
                    // Complete sticky calculation
                    sticky <= sticky | |partial_lo[11:0];
                    
                    state <= NORM;
                end
                
                NORM: begin
                    // Normalize result
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent;
                    overflow_flag <= &norm_exponent;
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Apply rounding with pre-computed overflow
                    if (round_inc) begin
                        {overflow_flag, z_mantissa} <= z_mantissa + 1;
                        if (overflow_flag) begin
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    state <= OUTPUT;
                end
                
                OUTPUT: begin
                    // Priority-based output selection
                    case (special_case)
                        NAN: z <= nan_out;
                        INF: z <= (a[30:0]==0 || b[30:0]==0) ? nan_out : inf_out;
                        ZERO: z <= zero_out;
                        default: begin
                            if (overflow_flag || &z_exponent) begin
                                z <= inf_out;
                            end else if (z_exponent == 0) begin
                                z <= zero_out;
                            end else begin
                                z <= normal_out;
                            end
                        end
                    endcase
                    
                    state <= EXTRACT;
                end
            endcase
        end
    end

endmodule