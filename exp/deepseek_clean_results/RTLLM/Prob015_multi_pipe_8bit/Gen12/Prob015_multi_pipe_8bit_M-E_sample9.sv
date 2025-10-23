module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1: Input registration and Booth encoding
    reg [7:0] stage1_a;
    reg [8:0] stage1_b;  // Extended by 1 bit for Booth encoding
    reg stage1_en;
    
    // Booth encoder outputs
    wire [1:0] booth_sel [3:0];
    wire [8:0] booth_pp [3:0];  // Partial products (9 bits to handle ±2A)
    
    // Pipeline stage 2: Wallace tree compression
    reg [15:0] stage2_result;
    reg stage2_en;
    
    // Final sum wires
    wire [15:0] sum_compressed;
    
    // Booth encoding (Radix-4)
    assign booth_sel[0] = {stage1_b[1], stage1_b[0]};
    assign booth_sel[1] = {stage1_b[3], stage1_b[2]};
    assign booth_sel[2] = {stage1_b[5], stage1_b[4]};
    assign booth_sel[3] = {stage1_b[7], stage1_b[6]};
    
    // Booth partial product generation
    generate
        genvar i;
        for (i = 0; i < 4; i = i + 1) begin : booth_pp_gen
            assign booth_pp[i] = 
                (booth_sel[i] == 2'b01) ? {1'b0, stage1_a} :          // +A
                (booth_sel[i] == 2'b10) ? {1'b0, stage1_a << 1} :      // +2A
                (booth_sel[i] == 2'b11) ? ~{1'b0, stage1_a} + 1'b1 :  // -A
                (booth_sel[i] == 2'b00) ? 9'b0 :                      // 0
                9'b0;
        end
    endgenerate
    
    // Wallace tree compression (4:2 compressor)
    wire [15:0] pp0_ext = {{7{booth_pp[0][8]}}, booth_pp[0]};
    wire [15:0] pp1_ext = {{5{booth_pp[1][8]}}, booth_pp[1], 2'b0};
    wire [15:0] pp2_ext = {{3{booth_pp[2][8]}}, booth_pp[2], 4'b0};
    wire [15:0] pp3_ext = {{1{booth_pp[3][8]}}, booth_pp[3], 6'b0};
    
    // First level compression
    wire [15:0] sum1, carry1;
    assign sum1 = pp0_ext ^ pp1_ext ^ pp2_ext;
    assign carry1 = (pp0_ext & pp1_ext) | (pp0_ext & pp2_ext) | (pp1_ext & pp2_ext);
    
    // Second level compression
    wire [15:0] sum2, carry2;
    assign sum2 = sum1 ^ carry1 ^ pp3_ext;
    assign carry2 = (sum1 & carry1) | (sum1 & pp3_ext) | (carry1 & pp3_ext);
    
    // Final addition
    assign sum_compressed = sum2 + (carry2 << 1);
    
    // Pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 9'b0;
            stage1_en <= 1'b0;
            stage2_result <= 16'b0;
            stage2_en <= 1'b0;
        end else begin
            // Stage 1: Register inputs and extend for Booth
            stage1_a <= mul_a;
            stage1_b <= {mul_b, 1'b0};  // Append 0 for Booth encoding
            stage1_en <= mul_en_in;
            
            // Stage 2: Register final result
            stage2_result <= sum_compressed;
            stage2_en <= stage1_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage2_en;
    assign mul_out = stage2_en ? stage2_result : 16'b0;

endmodule