module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Pipeline stage 1: Partial product generation (Booth encoded)
    reg signed [31:0] a_reg, b_reg;
    wire signed [63:0] pp [15:0];
    wire signed [63:0] sum_pp;
    
    // Booth encoder/selector
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : booth
            wire [2:0] sel = {b_reg[2*i+1], b_reg[2*i], (i == 0) ? 1'b0 : b_reg[2*i-1]};
            wire signed [32:0] pp_ext;
            
            always @(*) begin
                case (sel)
                    3'b000, 3'b111: pp_ext = 33'd0;
                    3'b001, 3'b010: pp_ext = {a_reg[31], a_reg};
                    3'b011:         pp_ext = {a_reg, 1'b0};
                    3'b100:         pp_ext = -{a_reg, 1'b0};
                    3'b101, 3'b110: pp_ext = -{a_reg[31], a_reg};
                endcase
            end
            
            assign pp[i] = {{(32-2*i){pp_ext[32]}}, pp_ext} << (2*i);
        end
    endgenerate
    
    // Partial product reduction tree (4:2 compressors)
    wire signed [63:0] stage1 [7:0];
    wire signed [63:0] stage2 [3:0];
    wire signed [63:0] stage3 [1:0];
    
    // First reduction stage
    generate
        for (i = 0; i < 8; i = i + 1) begin : reduce1
            assign stage1[i] = pp[2*i] + pp[2*i+1];
        end
    endgenerate
    
    // Second reduction stage
    generate
        for (i = 0; i < 4; i = i + 1) begin : reduce2
            assign stage2[i] = stage1[2*i] + stage1[2*i+1];
        end
    endgenerate
    
    // Final multiplier output
    assign sum_pp = stage2[0] + stage2[1] + stage2[2] + stage2[3];
    
    // Pipeline stage 2: Carry-save accumulation
    reg signed [31:0] sum_reg;
    reg signed [31:0] carry_reg;
    wire signed [31:0] next_sum, next_carry;
    
    // Carry-save addition
    assign {next_carry, next_sum} = {sum_reg[30:0], 1'b0} + carry_reg + sum_pp[31:0];
    
    // Final binary output conversion
    assign c = sum_reg + carry_reg;
    
    // Pipeline control
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'd0;
            b_reg <= 32'd0;
            sum_reg <= 32'd0;
            carry_reg <= 32'd0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            sum_reg <= next_sum;
            carry_reg <= next_carry;
        end
    end

endmodule