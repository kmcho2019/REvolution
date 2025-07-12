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
    reg [7:0] a_reg, b_reg;
    reg en_reg1;
    
    // Booth encoded partial products
    wire [8:0] booth_pp [3:0];
    wire [1:0] booth_sel [3:0];
    wire booth_neg [3:0];
    
    // Generate Booth encoding groups
    assign booth_sel[0] = {b_reg[1], b_reg[0]};
    assign booth_sel[1] = {b_reg[3], b_reg[2]};
    assign booth_sel[2] = {b_reg[5], b_reg[4]};
    assign booth_sel[3] = {b_reg[7], b_reg[6]};
    
    // Booth encoder and partial product generator
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_gen
            // Booth encoding
            assign booth_neg[i] = (booth_sel[i] == 2'b01) ? 1'b0 :
                                (booth_sel[i] == 2'b10) ? 1'b1 :
                                1'b0;
            
            // Partial product generation
            assign booth_pp[i] = (booth_sel[i] == 2'b00 || booth_sel[i] == 2'b11) ? 9'b0 :
                               (booth_sel[i] == 2'b01) ? {1'b0, a_reg} :
                               (booth_sel[i] == 2'b10) ? {1'b0, a_reg} :
                               9'b0;
        end
    endgenerate
    
    // Pipeline stage 2 registers
    reg [15:0] sum_reg;
    reg en_reg2;
    
    // Shifted and sign-extended partial products
    wire [15:0] pp0 = {{7{booth_neg[0]}}, booth_pp[0], 1'b0};
    wire [15:0] pp1 = {{5{booth_neg[1]}}, booth_pp[1], 3'b0};
    wire [15:0] pp2 = {{3{booth_neg[2]}}, booth_pp[2], 5'b0};
    wire [15:0] pp3 = {{1{booth_neg[3]}}, booth_pp[3], 7'b0};
    
    // Balanced adder tree
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] final_sum = sum01 + sum23;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            sum_reg <= 16'b0;
            en_reg2 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration + Booth encoding
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product accumulation
            sum_reg <= final_sum;
            en_reg2 <= en_reg1;
            
            // Output
            mul_en_out <= en_reg2;
            mul_out <= en_reg2 ? sum_reg : 16'b0;
        end
    end

endmodule