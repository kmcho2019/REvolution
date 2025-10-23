module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers with clock gating
    reg [7:0] a_reg, b_reg;
    reg en_reg1, en_reg2, en_reg3;
    wire clk_gated = clk & (mul_en_in | en_reg1 | en_reg2 | en_reg3);

    // Stage 1: Input registration and partial product generation
    reg [7:0] pp [0:7];  // Partial products
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            for (integer i = 0; i < 8; i++) pp[i] <= 8'b0;
        end else begin
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Generate partial products
            for (integer i = 0; i < 8; i++)
                pp[i] <= b_reg[i] ? a_reg : 8'b0;
        end
    end

    // Stage 2: Wallace Tree reduction (4:2 compressors)
    reg [11:0] sum1, carry1;
    reg [11:0] sum2, carry2;
    reg en_reg2;
    
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            sum1 <= 12'b0;
            carry1 <= 12'b0;
            sum2 <= 12'b0;
            carry2 <= 12'b0;
            en_reg2 <= 1'b0;
        end else begin
            en_reg2 <= en_reg1;
            
            // First level compression (8->4)
            for (integer i = 0; i < 4; i++) begin
                {carry1[2*i+1], sum1[2*i]} = pp[2*i] + pp[2*i+1];
                carry1[2*i] = 1'b0;
            end
            
            // Second level compression (4->2)
            {carry2[3], sum2[0]} = sum1[0] + sum1[1];
            {carry2[4], sum2[1]} = sum1[2] + sum1[3];
            {carry2[5], sum2[2]} = carry1[0] + carry1[1];
            {carry2[6], sum2[3]} = carry1[2] + carry1[3];
        end
    end

    // Stage 3: Final addition and output
    reg [15:0] result;
    reg en_reg3;
    
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
            en_reg3 <= 1'b0;
        end else begin
            en_reg3 <= en_reg2;
            // Final carry-propagate addition
            result <= {4'b0, sum2} + {3'b0, carry2, 1'b0};
        end
    end

    // Output assignments
    assign mul_en_out = en_reg3;
    assign mul_out = en_reg3 ? result : 16'b0;

endmodule