module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg1;
    reg [8:0] mul_b_ext_reg1;  // Extended for Booth encoding
    reg en_reg1;
    
    // Pipeline stage 2 registers
    reg [15:0] pp0_reg2, pp1_reg2, pp2_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers
    reg [15:0] final_sum_reg3;
    reg en_reg3;
    
    // Booth encoding signals
    wire [4:0] booth_sel;
    wire [15:0] booth_pp [2:0];
    
    // Stage 1: Input registration and Booth encoding
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg1 <= 8'b0;
            mul_b_ext_reg1 <= 9'b0;
            en_reg1 <= 1'b0;
        end else if (mul_en_in) begin
            mul_a_reg1 <= mul_a;
            mul_b_ext_reg1 <= {mul_b, 1'b0};  // Append 0 for Booth encoding
            en_reg1 <= 1'b1;
        end else begin
            en_reg1 <= 1'b0;
        end
    end
    
    // Booth encoder (radix-4)
    assign booth_sel[0] = (mul_b_ext_reg1[1:0] == 2'b01) || (mul_b_ext_reg1[1:0] == 2'b10);
    assign booth_sel[1] = (mul_b_ext_reg1[3:1] == 3'b001) || (mul_b_ext_reg1[3:1] == 3'b010);
    assign booth_sel[2] = (mul_b_ext_reg1[5:3] == 3'b001) || (mul_b_ext_reg1[5:3] == 3'b010);
    assign booth_sel[3] = (mul_b_ext_reg1[7:5] == 3'b001) || (mul_b_ext_reg1[7:5] == 3'b010);
    assign booth_sel[4] = (mul_b_ext_reg1[8:6] == 3'b001) || (mul_b_ext_reg1[8:6] == 3'b010);
    
    // Booth partial product generation
    assign booth_pp[0] = (mul_b_ext_reg1[1:0] == 2'b01) ? {8'b0, mul_a_reg1} :
                         (mul_b_ext_reg1[1:0] == 2'b10) ? ~{8'b0, mul_a_reg1} + 1'b1 :
                         16'b0;
    
    assign booth_pp[1] = (mul_b_ext_reg1[3:1] == 3'b001) ? {6'b0, mul_a_reg1, 2'b0} :
                         (mul_b_ext_reg1[3:1] == 3'b010) ? ~{6'b0, mul_a_reg1, 2'b0} + 1'b1 :
                         16'b0;
    
    assign booth_pp[2] = (mul_b_ext_reg1[5:3] == 3'b001) ? {4'b0, mul_a_reg1, 4'b0} :
                         (mul_b_ext_reg1[5:3] == 3'b010) ? ~{4'b0, mul_a_reg1, 4'b0} + 1'b1 :
                         16'b0;
    
    // Stage 2: Partial product registration and compression
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0_reg2 <= 16'b0;
            pp1_reg2 <= 16'b0;
            pp2_reg2 <= 16'b0;
            en_reg2 <= 1'b0;
        end else begin
            pp0_reg2 <= booth_pp[0];
            pp1_reg2 <= booth_pp[1];
            pp2_reg2 <= booth_pp[2];
            en_reg2 <= en_reg1;
        end
    end
    
    // Carry-save adder for partial products
    wire [15:0] sum_pp, carry_pp;
    assign sum_pp = pp0_reg2 ^ pp1_reg2 ^ pp2_reg2;
    assign carry_pp = ((pp0_reg2 & pp1_reg2) | (pp0_reg2 & pp2_reg2) | (pp1_reg2 & pp2_reg2)) << 1;
    
    // Stage 3: Final addition and output registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum_reg3 <= 16'b0;
            en_reg3 <= 1'b0;
        end else begin
            final_sum_reg3 <= sum_pp + carry_pp;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = en_reg3 ? final_sum_reg3 : 16'b0;
    end

endmodule