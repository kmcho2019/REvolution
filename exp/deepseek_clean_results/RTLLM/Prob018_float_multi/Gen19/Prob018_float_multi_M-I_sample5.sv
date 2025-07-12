module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg a_sign_p1, b_sign_p1;
    reg [7:0] a_exponent_p1, b_exponent_p1;
    reg [23:0] a_mant_norm_p1, b_mant_norm_p1;
    reg special_case_p1;
    reg [1:0] special_code_p1; // 00:normal, 01:zero, 10:inf, 11:nan
    
    reg a_sign_p2, b_sign_p2;
    reg [7:0] exp_sum_p2;
    reg [47:0] product_p2;
    reg special_case_p2;
    reg [1:0] special_code_p2;
    
    // Booth-encoded 24x24 multiplier
    function [47:0] booth_mult;
        input [23:0] a, b;
        reg [47:0] pp [0:11];
        reg [24:0] b_ext;
        integer i;
    begin
        b_ext = {b, 1'b0};
        pp[0] = 48'd0;
        for (i = 0; i < 12; i = i+1) begin
            case (b_ext[2*i+2:2*i])
                3'b000, 3'b111: pp[i+1] = pp[i];
                3'b001, 3'b010: pp[i+1] = pp[i] + (a << (2*i));
                3'b011:         pp[i+1] = pp[i] + (a << (2*i+1));
                3'b100:         pp[i+1] = pp[i] - (a << (2*i+1));
                3'b101, 3'b110: pp[i+1] = pp[i] - (a << (2*i));
            endcase
        end
        booth_mult = pp[12];
    end
    endfunction

    // Stage 1: Input processing and special case detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            special_case_p1 <= 0;
        end else begin
            stage <= stage + 1;
            
            // Extract components
            a_sign_p1 <= a[31];
            b_sign_p1 <= b[31];
            a_exponent_p1 <= a[30:23];
            b_exponent_p1 <= b[30:23];
            
            // Normalize mantissas with implicit bit
            a_mant_norm_p1 <= (a[30:23] != 0) ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
            b_mant_norm_p1 <= (b[30:23] != 0) ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
            
            // Special case detection
            if ((a[30:23] == 8'hFF && a[22:0] != 0) || 
                (b[30:23] == 8'hFF && b[22:0] != 0) begin
                special_case_p1 <= 1;
                special_code_p1 <= 2'b11; // NaN
            end else if ((a[30:23] == 8'hFF && b == 0) || 
                        (b[30:23] == 8'hFF && a == 0)) begin
                special_case_p1 <= 1;
                special_code_p1 <= 2'b11; // NaN (0*inf)
            end else if (a[30:23] == 8'hFF || b[30:23] == 8'hFF) begin
                special_case_p1 <= 1;
                special_code_p1 <= 2'b10; // Inf
            end else if (a == 0 || b == 0) begin
                special_case_p1 <= 1;
                special_code_p1 <= 2'b01; // Zero
            end else begin
                special_case_p1 <= 0;
            end
        end
    end

    // Stage 2: Multiplication and exponent calculation
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
        end else if (stage == 1) begin
            a_sign_p2 <= a_sign_p1;
            b_sign_p2 <= b_sign_p1;
            special_case_p2 <= special_case_p1;
            special_code_p2 <= special_code_p1;
            
            // Booth-encoded multiplication
            product_p2 <= booth_mult(a_mant_norm_p1, b_mant_norm_p1);
            
            // Exponent calculation (with bias adjustment)
            exp_sum_p2 <= a_exponent_p1 + b_exponent_p1 - 8'd127;
        end
    end

    // Stage 3: Normalization, rounding and output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
            stage <= 0;
        end else if (stage == 2) begin
            if (special_case_p2) begin
                case (special_code_p2)
                    2'b01: z <= {a_sign_p2 ^ b_sign_p2, 31'b0}; // Zero
                    2'b10: z <= {a_sign_p2 ^ b_sign_p2, 8'hFF, 23'b0}; // Inf
                    2'b11: z <= 32'h7FC00000; // NaN
                endcase
            end else begin
                // Normalization
                if (product_p2[47]) begin
                    z <= {a_sign_p2 ^ b_sign_p2, 
                          exp_sum_p2 + 1, 
                          product_p2[46:24]};
                end else begin
                    z <= {a_sign_p2 ^ b_sign_p2, 
                          exp_sum_p2, 
                          product_p2[45:23]};
                end
                
                // Overflow/underflow check
                if (exp_sum_p2 > 8'hFD || (exp_sum_p2 == 0 && product_p2[47])) begin
                    z <= {a_sign_p2 ^ b_sign_p2, 8'hFF, 23'b0};
                end
            end
        end
    end

endmodule