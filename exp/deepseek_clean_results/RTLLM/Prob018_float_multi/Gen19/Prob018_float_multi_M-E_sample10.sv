module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline stages
    localparam STAGE_INPUT = 0;
    localparam STAGE_MULT1 = 1;
    localparam STAGE_MULT2 = 2;
    localparam STAGE_NORM = 3;
    localparam STAGE_OUTPUT = 4;
    
    reg [2:0] stage;
    
    // Input decomposition
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    
    // Special case flags (combinational)
    wire a_zero = (a[30:0] == 0);
    wire b_zero = (b[30:0] == 0);
    wire a_inf = (&a[30:23]) && (a[22:0] == 0);
    wire b_inf = (&b[30:23]) && (b[22:0] == 0);
    wire a_nan = (&a[30:23]) && (|a[22:0]);
    wire b_nan = (&b[30:23]) && (|b[22:0]);
    wire special_case = a_nan || b_nan || ((a_inf || b_inf) && (a_zero || b_zero));
    
    // Pipeline registers
    reg [47:0] partial_products [0:15];
    reg [47:0] stage1_sum [0:7];
    reg [47:0] stage2_sum [0:3];
    reg [47:0] product;
    reg [9:0] exp_sum;
    reg sign_pipe [0:4];
    
    // Normalization prediction
    reg norm_shift_pred;
    wire [23:0] norm_man_shift0 = product[46:23];
    wire [23:0] norm_man_shift1 = product[47:24];
    wire [9:0] norm_exp_shift0 = exp_sum;
    wire [9:0] norm_exp_shift1 = exp_sum + 1;
    
    // Speculative rounding
    wire [23:0] norm_man = norm_shift_pred ? norm_man_shift1 : norm_man_shift0;
    wire [9:0] norm_exp = norm_shift_pred ? norm_exp_shift1 : norm_exp_shift0;
    wire guard = norm_shift_pred ? product[23] : product[22];
    wire round = norm_shift_pred ? product[22] : product[21];
    wire sticky = norm_shift_pred ? |product[21:0] : |product[20:0];
    wire round_inc = guard && (round || sticky || norm_man[0]);
    
    // Rounded results (both possibilities)
    wire [23:0] rounded_man_inc = norm_man + 1;
    wire [9:0] rounded_exp_inc = (&norm_man) ? norm_exp + 1 : norm_exp;
    wire [23:0] rounded_man_noinc = norm_man;
    wire [9:0] rounded_exp_noinc = norm_exp;
    
    // Final result selection
    wire [31:0] normal_result = round_inc ? 
        {sign_pipe[4], rounded_exp_inc[7:0], rounded_man_inc[22:0]} :
        {sign_pipe[4], rounded_exp_noinc[7:0], rounded_man_noinc[22:0]};
    wire [31:0] special_result = a_nan || b_nan ? 32'h7FC00000 :
                               (a_inf || b_inf) ? {sign_pipe[4], 8'hFF, 23'b0} :
                               {sign_pipe[4], 31'b0}; // zero
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= STAGE_INPUT;
            z <= 0;
        end else begin
            case (stage)
                STAGE_INPUT: begin
                    // Decompose inputs
                    a_sign <= a[31];
                    b_sign <= a[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_man <= (|a[30:23]) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_man <= (|b[30:23]) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    
                    // Initialize pipeline
                    sign_pipe[0] <= a[31] ^ b[31];
                    exp_sum <= {2'b0, a[30:23]} + {2'b0, b[30:23]} - 10'd127;
                    
                    // Generate partial products (Booth encoded)
                    for (integer i = 0; i < 16; i = i+1) begin
                        partial_products[i] <= (b_man[2*i+1:2*i-1] == 3'b000) ? 48'b0 :
                                            (b_man[2*i+1:2*i-1] == 3'b001) ? {26'b0, a_man} :
                                            (b_man[2*i+1:2*i-1] == 3'b010) ? {25'b0, a_man, 1'b0} :
                                            (b_man[2*i+1:2*i-1] == 3'b011) ? {24'b0, a_man, 2'b0} :
                                            (b_man[2*i+1:2*i-1] == 3'b100) ? {24'b0, ~a_man, 2'b0} + 1 :
                                            (b_man[2*i+1:2*i-1] == 3'b101) ? {25'b0, ~a_man, 1'b0} + 1 :
                                            (b_man[2*i+1:2*i-1] == 3'b110) ? {26'b0, ~a_man} + 1 :
                                            48'b0;
                    end
                    
                    stage <= STAGE_MULT1;
                end
                
                STAGE_MULT1: begin
                    // First stage of Wallace tree reduction
                    for (integer i = 0; i < 8; i = i+1) begin
                        stage1_sum[i] <= partial_products[2*i] + partial_products[2*i+1];
                    end
                    sign_pipe[1] <= sign_pipe[0];
                    stage <= STAGE_MULT2;
                end
                
                STAGE_MULT2: begin
                    // Second stage of Wallace tree reduction
                    for (integer i = 0; i < 4; i = i+1) begin
                        stage2_sum[i] <= stage1_sum[2*i] + stage1_sum[2*i+1];
                    end
                    sign_pipe[2] <= sign_pipe[1];
                    stage <= STAGE_NORM;
                end
                
                STAGE_NORM: begin
                    // Final addition and normalization prediction
                    product <= stage2_sum[0] + stage2_sum[1] + stage2_sum[2] + stage2_sum[3];
                    norm_shift_pred <= product[47]; // Predict normalization shift
                    sign_pipe[3] <= sign_pipe[2];
                    stage <= STAGE_OUTPUT;
                end
                
                STAGE_OUTPUT: begin
                    // Select final result
                    if (special_case) begin
                        z <= special_result;
                    end else if (rounded_exp_inc[9] || (&rounded_exp_inc[7:0])) begin // Overflow
                        z <= {sign_pipe[4], 8'hFF, 23'b0};
                    end else if (rounded_exp_noinc == 0) begin // Underflow
                        z <= {sign_pipe[4], 31'b0};
                    end else begin
                        z <= normal_result;
                    end
                    sign_pipe[4] <= sign_pipe[3];
                    stage <= STAGE_INPUT;
                end
            endcase
        end
    end

endmodule