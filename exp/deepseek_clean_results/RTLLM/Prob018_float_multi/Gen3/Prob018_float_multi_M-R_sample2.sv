module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Parameters for state machine
    parameter IDLE = 1'b0;
    parameter COMPUTE = 1'b1;
    reg state;

    // Continuous assignments for special cases
    wire a_is_nan = &a[30:23] && |a[22:0];
    wire b_is_nan = &b[30:23] && |b[22:0];
    wire a_is_inf = &a[30:23] && ~|a[22:0];
    wire b_is_inf = &b[30:23] && ~|b[22:0];
    wire a_is_zero = ~|a[30:0];
    wire b_is_zero = ~|b[30:0];
    wire any_nan = a_is_nan || b_is_nan;
    wire inf_times_zero = (a_is_inf && b_is_zero) || (b_is_inf && a_is_zero);
    wire special_case = any_nan || inf_times_zero || a_is_inf || b_is_inf || a_is_zero || b_is_zero;

    // Pipeline registers
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    reg [47:0] product;

    // Combinational outputs
    wire [47:0] product_wire;
    wire [30:0] normalized;
    wire [23:0] rounded_man;
    wire [7:0] rounded_exp;
    wire z_sign = a_sign ^ b_sign;
    wire [7:0] exp_sum = a_exp + b_exp - 8'd127;

    // Mantissa multiplication (shift-and-add)
    assign product_wire = 
        (b_man[0] ? {24'b0, a_man} : 48'b0) +
        (b_man[1] ? {23'b0, a_man, 1'b0} : 48'b0) +
        (b_man[2] ? {22'b0, a_man, 2'b0} : 48'b0) +
        (b_man[3] ? {21'b0, a_man, 3'b0} : 48'b0) +
        (b_man[4] ? {20'b0, a_man, 4'b0} : 48'b0) +
        (b_man[5] ? {19'b0, a_man, 5'b0} : 48'b0) +
        (b_man[6] ? {18'b0, a_man, 6'b0} : 48'b0) +
        (b_man[7] ? {17'b0, a_man, 7'b0} : 48'b0) +
        (b_man[8] ? {16'b0, a_man, 8'b0} : 48'b0) +
        (b_man[9] ? {15'b0, a_man, 9'b0} : 48'b0) +
        (b_man[10] ? {14'b0, a_man, 10'b0} : 48'b0) +
        (b_man[11] ? {13'b0, a_man, 11'b0} : 48'b0) +
        (b_man[12] ? {12'b0, a_man, 12'b0} : 48'b0) +
        (b_man[13] ? {11'b0, a_man, 13'b0} : 48'b0) +
        (b_man[14] ? {10'b0, a_man, 14'b0} : 48'b0) +
        (b_man[15] ? {9'b0, a_man, 15'b0} : 48'b0) +
        (b_man[16] ? {8'b0, a_man, 16'b0} : 48'b0) +
        (b_man[17] ? {7'b0, a_man, 17'b0} : 48'b0) +
        (b_man[18] ? {6'b0, a_man, 18'b0} : 48'b0) +
        (b_man[19] ? {5'b0, a_man, 19'b0} : 48'b0) +
        (b_man[20] ? {4'b0, a_man, 20'b0} : 48'b0) +
        (b_man[21] ? {3'b0, a_man, 21'b0} : 48'b0) +
        (b_man[22] ? {2'b0, a_man, 22'b0} : 48'b0) +
        (b_man[23] ? {1'b0, a_man, 23'b0} : 48'b0);

    // Normalization
    assign normalized = product[47] ? 
        {exp_sum + 1, product[46:24]} : 
        (product[46] ? {exp_sum, product[45:23]} : 
        (product[45] ? {exp_sum - 1, product[44:22]} : 
        (product[44] ? {exp_sum - 2, product[43:21]} : 
        (product[43] ? {exp_sum - 3, product[42:20]} : 
        {8'b0, 23'b0})))); // Underflow to zero

    // Rounding
    wire guard = normalized[22];
    wire round = normalized[21];
    wire sticky = |normalized[20:0];
    wire round_up = guard && (round || sticky || normalized[23]);
    assign rounded_man = round_up ? normalized[30:8] + 1 : normalized[30:8];
    assign rounded_exp = round_up && &normalized[30:8] ? normalized[7:0] + 1 : normalized[7:0];

    // Main state machine
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            z <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (special_case) begin
                        if (any_nan || inf_times_zero) begin
                            z <= {1'b0, 8'hFF, 23'h400000}; // qNaN
                        end else if (a_is_inf || b_is_inf) begin
                            z <= {a[31] ^ b[31], 8'hFF, 23'h0}; // Inf
                        end else begin // Zero
                            z <= {a[31] ^ b[31], 31'h0};
                        end
                    end else begin
                        // Register inputs
                        a_sign <= a[31];
                        b_sign <= b[31];
                        a_exp <= a[30:23];
                        b_exp <= b[30:23];
                        a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                        b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                        state <= COMPUTE;
                    end
                end
                
                COMPUTE: begin
                    product <= product_wire;
                    
                    // Handle overflow/underflow
                    if (rounded_exp[7] || (&rounded_exp)) begin
                        z <= rounded_exp[7] ? {z_sign, 31'h0} : {z_sign, 8'hFF, 23'h0};
                    end else begin
                        z <= {z_sign, rounded_exp, rounded_man[22:0]};
                    end
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule