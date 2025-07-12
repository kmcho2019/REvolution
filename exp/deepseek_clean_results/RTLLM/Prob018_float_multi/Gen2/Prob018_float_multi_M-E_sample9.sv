module float_multi (
    input clk,
    input rst,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] z
);

    // Fast path signals
    reg fast_valid;
    reg [31:0] fast_result;
    
    // Main path signals
    reg [2:0] main_stage;
    reg [31:0] main_result;
    
    // Shared signals
    reg a_sign, b_sign;
    reg [7:0] a_exp, b_exp;
    reg [23:0] a_man, b_man;
    reg [47:0] product;
    
    // Special case detection
    wire a_nan = &a[30:23] && |a[22:0];
    wire b_nan = &b[30:23] && |b[22:0];
    wire a_inf = &a[30:23] && ~|a[22:0];
    wire b_inf = &b[30:23] && ~|b[22:0];
    wire a_zero = ~|a[30:23] && ~|a[22:0];
    wire b_zero = ~|b[30:23] && ~|b[22:0];
    
    // Fast path processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fast_valid <= 0;
            fast_result <= 0;
        end else begin
            fast_valid <= 0;
            
            // NaN cases have highest priority
            if (a_nan || b_nan) begin
                fast_result <= {1'b0, 8'hFF, 23'h400000}; // Canonical NaN
                fast_valid <= 1;
            end 
            // Infinity * zero = NaN
            else if ((a_inf && b_zero) || (b_inf && a_zero)) begin
                fast_result <= {1'b0, 8'hFF, 23'h400000};
                fast_valid <= 1;
            end
            // Infinity cases
            else if (a_inf || b_inf) begin
                fast_result <= {a[31] ^ b[31], 8'hFF, 23'h0};
                fast_valid <= 1;
            end
            // Zero cases
            else if (a_zero || b_zero) begin
                fast_result <= {a[31] ^ b[31], 31'h0};
                fast_valid <= 1;
            end
        end
    end
    
    // Main path processing
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            main_stage <= 0;
            main_result <= 0;
        end else if (~fast_valid) begin
            case (main_stage)
                0: begin // Stage 0: Input processing
                    a_sign <= a[31];
                    b_sign <= b[31];
                    a_exp <= a[30:23];
                    b_exp <= b[30:23];
                    a_man <= |a[30:23] ? {1'b1, a[22:0]} : {1'b0, a[22:0]};
                    b_man <= |b[30:23] ? {1'b1, b[22:0]} : {1'b0, b[22:0]};
                    main_stage <= 1;
                end
                
                1: begin // Stage 1: Multiplication
                    product <= a_man * b_man;
                    main_stage <= 2;
                end
                
                2: begin // Stage 2: Normalization and rounding
                    reg [7:0] final_exp;
                    reg [22:0] final_man;
                    reg guard, round, sticky;
                    
                    // Calculate preliminary exponent
                    final_exp = a_exp + b_exp - 8'd127;
                    
                    // Normalize
                    if (product[47]) begin
                        final_man = product[46:24];
                        final_exp = final_exp + 1;
                    end else begin
                        final_man = product[45:23];
                    end
                    
                    // Rounding (nearest even)
                    guard = product[22];
                    round = product[21];
                    sticky = |product[20:0];
                    
                    if (guard && (round || sticky || final_man[0])) begin
                        {final_exp, final_man} = final_man + 1 > 24'hFFFFFF ? 
                                                 {final_exp + 1, 23'h0} : 
                                                 {final_exp, final_man + 1};
                    end
                    
                    // Handle overflow/underflow
                    if (&final_exp || (final_exp == 0 && final_man != 0)) begin
                        main_result <= {a_sign ^ b_sign, 8'hFF, 23'h0}; // Infinity
                    end else if (final_exp == 0) begin
                        main_result <= {a_sign ^ b_sign, 31'h0}; // Zero
                    end else begin
                        main_result <= {a_sign ^ b_sign, final_exp, final_man};
                    end
                    
                    main_stage <= 0;
                end
            endcase
        end
    end
    
    // Output selection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            z <= 0;
        end else begin
            z <= fast_valid ? fast_result : 
                 (main_stage == 0) ? main_result : z;
        end
    end

endmodule