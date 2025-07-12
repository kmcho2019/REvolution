module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Pipeline registers
    reg signed [31:0] a_reg, b_reg;
    reg signed [63:0] product_reg;
    reg signed [31:0] accum_reg;
    
    // Booth encoded partial products
    wire signed [32:0] booth_pp [15:0];
    
    // Carry-save signals
    wire signed [31:0] sum, carry;
    
    // Overflow detection
    wire overflow;
    
    // Stage 1: Booth encoding and partial product generation
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end
    
    // Generate Booth encoded partial products
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth
            wire [2:0] sel = {b_reg[2*i+1], b_reg[2*i], (i == 0) ? 1'b0 : b_reg[2*i-1]};
            wire neg = sel[2];
            wire zero = (sel[1:0] == 2'b00) || (sel[1:0] == 2'b11);
            wire two = sel[0] ^ sel[1];
            
            assign booth_pp[i] = zero ? 33'd0 : 
                               (two ? {a_reg[31], a_reg} << 1 : 
                               {a_reg[31], a_reg});
            assign booth_pp[i] = neg ? -booth_pp[i] : booth_pp[i];
        end
    endgenerate
    
    // Stage 1: Partial product reduction tree (simplified for illustration)
    always @(posedge clk) begin
        product_reg <= booth_pp[0] + booth_pp[1] + booth_pp[2] + booth_pp[3] + 
                       booth_pp[4] + booth_pp[5] + booth_pp[6] + booth_pp[7] +
                       booth_pp[8] + booth_pp[9] + booth_pp[10] + booth_pp[11] +
                       booth_pp[12] + booth_pp[13] + booth_pp[14] + booth_pp[15];
    end
    
    // Stage 2: Carry-save accumulation
    assign {sum, carry} = accum_reg + product_reg[31:0];
    
    // Overflow detection
    assign overflow = (product_reg[63:32] != {32{product_reg[31]}}) || 
                     ((accum_reg[31] == product_reg[31]) && 
                      (sum[31] != accum_reg[31]));
    
    // Stage 2: Final accumulation
    always @(posedge clk) begin
        if (rst) begin
            accum_reg <= 32'd0;
            c <= 32'd0;
        end else begin
            accum_reg <= sum + {carry[30:0], 1'b0}; // Final carry merge
            c <= overflow ? (accum_reg[31] ? 32'h80000000 : 32'h7FFFFFFF) : 
                           (sum + {carry[30:0], 1'b0});
        end
    end

endmodule