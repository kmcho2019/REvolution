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
    reg [7:0] mul_a_reg;
    reg [8:0] mul_b_ext; // Extended for Booth encoding
    reg en_reg1;
    
    // Booth encoder signals
    wire [3:0] booth_sel;
    wire [8:0] booth_pp [3:0];
    
    // Pipeline stage 2 registers
    reg [15:0] sum_reg;
    reg [15:0] carry_reg;
    reg en_reg2;
    
    // Booth encoding
    assign mul_b_ext = {mul_b, 1'b0}; // Append 0 for Booth encoding
    
    // Generate Booth select signals
    assign booth_sel[0] = {mul_b_ext[1:0], 1'b0} == 3'b001 || 
                         {mul_b_ext[1:0], 1'b0} == 3'b010;
    assign booth_sel[1] = {mul_b_ext[3:1], 1'b0} == 3'b001 || 
                         {mul_b_ext[3:1], 1'b0} == 3'b010;
    assign booth_sel[2] = {mul_b_ext[5:3], 1'b0} == 3'b001 || 
                         {mul_b_ext[5:3], 1'b0} == 3'b010;
    assign booth_sel[3] = {mul_b_ext[7:5], 1'b0} == 3'b001 || 
                         {mul_b_ext[7:5], 1'b0} == 3'b010;
    
    // Generate partial products with proper shifting and sign extension
    assign booth_pp[0] = booth_sel[0] ? {8'b0, mul_a_reg} : 9'b0;
    assign booth_pp[1] = booth_sel[1] ? {6'b0, mul_a_reg, 2'b0} : 9'b0;
    assign booth_pp[2] = booth_sel[2] ? {4'b0, mul_a_reg, 4'b0} : 9'b0;
    assign booth_pp[3] = booth_sel[3] ? {2'b0, mul_a_reg, 6'b0} : 9'b0;
    
    // Carry-save adder tree
    wire [15:0] sum1, carry1;
    wire [15:0] sum2, carry2;
    
    // First level of CSA
    assign {carry1, sum1} = booth_pp[0] + booth_pp[1];
    assign {carry2, sum2} = booth_pp[2] + booth_pp[3];
    
    // Final addition
    wire [15:0] final_sum = sum1 + sum2 + carry1 + carry2;
    
    // Pipeline control with clock gating
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            mul_a_reg <= 8'b0;
            mul_b_ext <= 9'b0;
            en_reg1 <= 1'b0;
            
            sum_reg <= 16'b0;
            carry_reg <= 16'b0;
            en_reg2 <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration and Booth encoding
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_ext <= {mul_b, 1'b0};
            end
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product accumulation
            if (en_reg1) begin
                sum_reg <= sum1 + sum2;
                carry_reg <= carry1 + carry2;
            end
            en_reg2 <= en_reg1;
            
            // Output
            mul_en_out <= en_reg2;
            mul_out <= en_reg2 ? final_sum : 16'b0;
        end
    end

endmodule