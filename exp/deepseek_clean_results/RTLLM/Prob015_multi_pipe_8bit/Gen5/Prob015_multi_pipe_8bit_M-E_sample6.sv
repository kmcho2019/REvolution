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
    
    // Pipeline stage 2 registers
    reg [15:0] result_reg;
    reg en_reg2;
    
    // Booth encoder outputs (stage 1)
    wire [2:0] booth_sel [3:0];
    wire [8:0] a_ext = {mul_a[7], mul_a}; // Sign extended
    
    // Generate booth encoding
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : booth_enc
            localparam [2:0] lsb = i*2;
            wire [2:0] b_group = (lsb == 6) ? 
                {mul_b[7], mul_b[7], mul_b[6]} : 
                {mul_b[lsb+1], mul_b[lsb], (lsb > 0) ? mul_b[lsb-1] : 1'b0};
            
            // Booth encoding logic
            assign booth_sel[i] = 
                (b_group == 3'b000 || b_group == 3'b111) ? 3'b000 : // 0
                (b_group == 3'b001 || b_group == 3'b010) ? 3'b001 : // +1
                (b_group == 3'b011) ? 3'b010 : // +2
                (b_group == 3'b100) ? 3'b110 : // -2
                3'b101; // -1 (101 or 110)
        end
    endgenerate
    
    // Partial products (stage 2)
    wire [15:0] pp [3:0];
    wire [15:0] pp0, pp1, pp2, pp3;
    
    // Generate partial products with proper shifting and sign
    assign pp0 = booth_sel[0][2] ? 
                 ~{ {8{booth_sel[0][1]}}, (a_reg << booth_sel[0][0]) } + 1 : 
                 { {8{booth_sel[0][1]}}, (a_reg << booth_sel[0][0]) };
    
    assign pp1 = booth_sel[1][2] ? 
                 ~{ {6{booth_sel[1][1]}}, (a_reg << booth_sel[1][0]), 2'b0 } + 1 : 
                 { {6{booth_sel[1][1]}}, (a_reg << booth_sel[1][0]), 2'b0 };
    
    assign pp2 = booth_sel[2][2] ? 
                 ~{ {4{booth_sel[2][1]}}, (a_reg << booth_sel[2][0]), 4'b0 } + 1 : 
                 { {4{booth_sel[2][1]}}, (a_reg << booth_sel[2][0]), 4'b0 };
    
    assign pp3 = booth_sel[3][2] ? 
                 ~{ {2{booth_sel[3][1]}}, (a_reg << booth_sel[3][0]), 6'b0 } + 1 : 
                 { {2{booth_sel[3][1]}}, (a_reg << booth_sel[3][0]), 6'b0 };
    
    // Carry-save adder tree
    wire [15:0] sum1 = pp0 + pp1;
    wire [15:0] sum2 = pp2 + pp3;
    wire [15:0] final_sum = sum1 + sum2;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            result_reg <= 16'b0;
            en_reg2 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration and Booth encoding
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product summation
            result_reg <= final_sum;
            en_reg2 <= en_reg1;
            
            // Output
            mul_en_out <= en_reg2;
            mul_out <= en_reg2 ? result_reg : 16'b0;
        end
    end

endmodule