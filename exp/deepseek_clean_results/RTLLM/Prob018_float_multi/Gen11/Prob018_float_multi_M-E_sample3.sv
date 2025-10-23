module float_multi(
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Pipeline registers
    reg [1:0] stage;
    reg a_sign_pipe, b_sign_pipe;
    reg [7:0] a_exponent_pipe, b_exponent_pipe;
    reg [23:0] a_mantissa_pipe, b_mantissa_pipe;
    reg special_case_pipe;
    reg [7:0] exp_sum_pipe;
    
    // Multiply stage signals
    reg [47:0] product;
    reg [8:0] exp_adj;
    reg sign_result;
    
    // Normalize stage signals
    reg [7:0] final_exponent;
    reg [22:0] final_mantissa;
    reg [2:0] norm_shift;
    reg sticky_bit;
    
    // Special case detection
    wire a_zero = (a[30:23] == 0) && (a[22:0] == 0);
    wire b_zero = (b[30:23] == 0) && (b[22:0] == 0);
    wire a_inf = (a[30:23] == 8'hFF) && (a[22:0] == 0);
    wire b_inf = (b[30:23] == 8'hFF) && (b[22:0] == 0);
    wire a_nan = (a[30:23] == 8'hFF) && (a[22:0] != 0);
    wire b_nan = (b[30:23] == 8'hFF) && (b[22:0] != 0);
    wire special_case = a_nan | b_nan | a_inf | b_inf | a_zero | b_zero;
    
    // Modified Booth multiplier (24x24)
    function [47:0] booth_mult;
        input [23:0] a, b;
        reg [47:0] pp [0:11];
        reg [24:0] b_ext;
        integer i;
    begin
        b_ext = {b, 1'b0};
        for (i = 0; i < 12; i = i+1) begin
            case (b_ext[2*i+2:2*i])
                3'b000, 3'b111: pp[i] = 0;
                3'b001, 3'b010: pp[i] = {{24{a[23]}}, a};
                3'b011:         pp[i] = {{23{a[23]}}, a, 1'b0};
                3'b100:         pp[i] = -{{23{a[23]}}, a, 1'b0};
                3'b101, 3'b110: pp[i] = -{{24{a[23]}}, a};
            endcase
            pp[i] = pp[i] << (2*i);
        end
        
        booth_mult = pp[0] + pp[1] + pp[2] + pp[3] + pp[4] + pp[5] +
                     pp[6] + pp[7] + pp[8] + pp[9] + pp[10] + pp[11];
    end
    endfunction
    
    // Pipeline stage 1: Input processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage <= 0;
            a_sign_pipe <= 0;
            b_sign_pipe <= 0;
            a_exponent_pipe <= 0;
            b_exponent_pipe <= 0;
            a_mantissa_pipe <= 0;
            b_mantissa_pipe <= 0;
            special_case_pipe <= 0;
            exp_sum_pipe <= 0;
        end else begin
            stage <= stage + 1;
            
            // Extract components
            a_sign_pipe <= a[31];
            b_sign_pipe <= b[31];
            a_exponent_pipe <= a[30:23];
            b_exponent_pipe <= b[30:23];
            
            // Handle denormals
            a_mantissa_pipe <= (a[30:23] == 0) ? {1'b0, a[22:0]} : {1'b1, a[22:0]};
            b_mantissa_pipe <= (b[30:23] == 0) ? {1'b0, b[22:0]} : {1'b1, b[22:0]};
            
            // Special cases and exponent sum
            special_case_pipe <= special_case;
            exp_sum_pipe <= a[30:23] + b[30:23];
        end
    end
    
    // Pipeline stage 2: Multiplication
    always @(posedge clk) begin
        if (stage == 1) begin
            // Booth multiplication
            product <= booth_mult(a_mantissa_pipe, b_mantissa_pipe);
            
            // Exponent adjustment
            exp_adj <= {1'b0, exp_sum_pipe} - 9'd127;
            
            // Sign calculation
            sign_result <= a_sign_pipe ^ b_sign_pipe;
        end
    end
    
    // Pipeline stage 3: Normalization and rounding
    always @(posedge clk) begin
        if (stage == 2) begin
            // Leading-one detection
            norm_shift <= product[47] ? 0 : 
                         product[46] ? 1 :
                         product[45] ? 2 :
                         product[44] ? 3 :
                         product[43] ? 4 : 5;
            
            // Sticky bit calculation
            sticky_bit <= |product[norm_shift+22:0];
            
            // Final mantissa with rounding
            final_mantissa <= product[47] ? product[46:24] + (product[23] & (product[22] | sticky_bit)) :
                              product[46:24] >> norm_shift;
            
            // Final exponent
            final_exponent <= product[47] ? exp_adj[7:0] + 1 : 
                              exp_adj[7:0] - norm_shift;
        end
    end
    
    // Output stage
    always @(posedge clk) begin
        if (stage == 2) begin
            if (special_case_pipe) begin
                // Handle special cases
                if (a_nan || b_nan) begin
                    z <= 32'h7FC00000; // NaN
                end else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                    z <= 32'h7FC00000; // NaN (0*inf)
                end else if (a_inf || b_inf) begin
                    z <= {sign_result, 8'hFF, 23'b0}; // Infinity
                end else begin // Zero
                    z <= {sign_result, 31'b0};
                end
            end else if (exp_adj[8] || (&final_exponent[7:0])) begin // Overflow/underflow
                z <= {sign_result, 8'hFF, 23'b0}; // Infinity
            end else begin
                z <= {sign_result, final_exponent, final_mantissa[22:0]};
            end
        end
    end

endmodule