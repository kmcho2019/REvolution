module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (input)
    reg [7:0] mul_a_reg1, mul_b_reg1;
    reg en_reg1;
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] pp_reg2 [3:0];  // Stores pp0+pp1, pp2+pp3, pp4+pp5, pp6+pp7
    reg en_reg2;
    
    // Pipeline stage 3 registers (final sum)
    reg [15:0] sum_reg3;
    reg en_reg3;
    
    // Generate all partial products
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? ({8'b0, mul_a_reg1} << i) : 16'b0;
        end
    endgenerate
    
    // First level sums (combinational)
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];
    
    // Second level sums (combinational)
    wire [15:0] sum_low = pp_reg2[0] + pp_reg2[1];
    wire [15:0] sum_high = pp_reg2[2] + pp_reg2[3];
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            pp_reg2[0] <= 16'b0;
            pp_reg2[1] <= 16'b0;
            pp_reg2[2] <= 16'b0;
            pp_reg2[3] <= 16'b0;
            sum_reg3 <= 16'b0;
            
            // Reset enable signals
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg1 <= mul_a;
            mul_b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product sums registration
            pp_reg2[0] <= sum01;
            pp_reg2[1] <= sum23;
            pp_reg2[2] <= sum45;
            pp_reg2[3] <= sum67;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final sum registration
            sum_reg3 <= sum_low + sum_high;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = sum_reg3;
    end

endmodule