module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // One-hot state encoding
    localparam EXTRACT = 5'b00001;
    localparam MULT1   = 5'b00010;
    localparam MULT2   = 5'b00100;
    localparam NORM    = 5'b01000;
    localparam ROUND   = 5'b10000;

    reg [4:0] state;
    reg [23:0] a_mantissa, b_mantissa, z_mantissa;
    reg [7:0] a_exponent, b_exponent, z_exponent;
    reg a_sign, b_sign, z_sign;
    reg [46:0] product;  // 24x24 needs only 47 bits
    reg guard_bit, round_bit, sticky;
    
    // Clock gating signals
    wire mult_clk_en = (state == MULT1) || (state == MULT2);
    wire product_clk = mult_clk_en ? clk : 1'b0;
    
    // Special case flags (shared)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    
    // Intermediate signals
    wire [8:0] exp_sum = {1'b0, a_exponent} + {1'b0, b_exponent};
    wire [8:0] exp_biased = exp_sum - 9'd127;
    wire sign_result = a_sign ^ b_sign;
    
    // Pipelined multiplier signals
    reg [23:0] mult_a, mult_b;
    reg [23:0] partial_products [0:11];
    integer i;
    
    // Normalization signals
    wire [23:0] norm_mantissa = product[46] ? product[46:23] : product[45:22];
    wire [8:0] norm_exponent = product[46] ? (exp_biased + 1) : exp_biased;
    
    // Carry-save rounding adder
    wire [23:0] rounded_mantissa;
    wire rounding_overflow;
    assign {rounding_overflow, rounded_mantissa} = z_mantissa + {23'b0, round_inc};
    wire round_inc = guard_bit && (round_bit || sticky || z_mantissa[0]);
    
    // Output selection
    wire [31:0] nan_out = 32'h7FC00000;
    wire [31:0] inf_out = {z_sign, 8'hFF, 23'b0};
    wire [31:0] zero_out = {z_sign, 31'b0};
    wire [31:0] normal_out = {z_sign, z_exponent[7:0], z_mantissa[22:0]};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= EXTRACT;
            z <= 0;
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
                    
                    state <= MULT1;
                end
                
                MULT1: begin
                    // Stage 1: Generate partial products
                    mult_a <= a_mantissa;
                    mult_b <= b_mantissa;
                    for (i = 0; i < 12; i = i+1)
                        partial_products[i] <= mult_b[i*2 +: 2] * mult_a;
                    
                    z_exponent <= exp_biased[7:0];
                    z_sign <= sign_result;
                    state <= MULT2;
                end
                
                MULT2: begin
                    // Stage 2: Sum partial products
                    reg [47:0] temp_sum = 0;
                    for (i = 0; i < 12; i = i+1)
                        temp_sum = temp_sum + (partial_products[i] << (i*2));
                    product <= temp_sum[46:0];
                    
                    state <= NORM;
                end
                
                NORM: begin
                    // Normalize result
                    z_mantissa <= norm_mantissa;
                    z_exponent <= norm_exponent[7:0];
                    
                    // Extract rounding bits
                    guard_bit <= product[22];
                    round_bit <= product[21];
                    sticky <= |product[20:0];
                    
                    state <= ROUND;
                end
                
                ROUND: begin
                    // Apply rounding with carry-save adder
                    if (round_inc) begin
                        z_mantissa <= rounded_mantissa;
                        if (rounding_overflow) begin
                            z_mantissa <= {1'b1, 23'b0};
                            z_exponent <= z_exponent + 1;
                        end
                    end
                    
                    // Output selection
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
                    else if (z_exponent == 8'hFF || norm_exponent[8]) begin // Overflow
                        z <= inf_out;
                    end
                    else if (z_exponent == 0) begin // Underflow
                        z <= zero_out;
                    end
                    else begin
                        z <= normal_out;
                    end
                    
                    state <= EXTRACT;
                end
            endcase
        end
    end

    // Clock-gated product register
    always @(posedge product_clk or posedge rst) begin
        if (rst) begin
            product <= 0;
        end else if (state == MULT2) begin
            // Product updated in MULT2 state
        end
    end

endmodule