module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline parameters
    parameter PIPELINE_DEPTH = 4;
    
    // Pipeline registers
    reg [PIPELINE_DEPTH-1:0] en_pipe = 0;
    reg [7:0] a_reg, b_reg;
    
    // Partial products (enable-gated)
    wire [15:0] pp [0:7];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = en_pipe[0] ? (b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0) : 16'b0;
        end
    endgenerate

    // Carry-save adder stages
    reg [8:0] csa1_sum0, csa1_sum1, csa1_carry0, csa1_carry1;
    reg [9:0] csa2_sum, csa2_carry;
    reg [15:0] final_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            en_pipe <= 0;
            a_reg <= 0;
            b_reg <= 0;
            csa1_sum0 <= 0;
            csa1_sum1 <= 0;
            csa1_carry0 <= 0;
            csa1_carry1 <= 0;
            csa2_sum <= 0;
            csa2_carry <= 0;
            final_sum <= 0;
        end else begin
            // Pipeline stage 0: Input sampling
            en_pipe <= {en_pipe[PIPELINE_DEPTH-2:0], mul_en_in};
            if (mul_en_in) begin
                a_reg <= mul_a;
                b_reg <= mul_b;
            end

            // Pipeline stage 1: First CSA level (8+9 bits)
            if (en_pipe[0]) begin
                {csa1_carry0, csa1_sum0} <= pp[0] + pp[1] + pp[2];
                {csa1_carry1, csa1_sum1} <= pp[3] + pp[4] + pp[5];
            end else begin
                csa1_sum0 <= 0;
                csa1_sum1 <= 0;
                csa1_carry0 <= 0;
                csa1_carry1 <= 0;
            end

            // Pipeline stage 2: Second CSA level (10+11 bits)
            if (en_pipe[1]) begin
                {csa2_carry, csa2_sum} <= 
                    {1'b0, csa1_sum0} + 
                    {2'b0, csa1_sum1} + 
                    {2'b0, csa1_carry0} + 
                    pp[6] + pp[7] + {3'b0, csa1_carry1};
            end else begin
                csa2_sum <= 0;
                csa2_carry <= 0;
            end

            // Pipeline stage 3: Final addition (16 bits)
            if (en_pipe[2]) begin
                final_sum <= csa2_sum + {csa2_carry, 5'b0};
            end else begin
                final_sum <= 0;
            end
        end
    end

    // Output assignments
    assign mul_en_out = en_pipe[PIPELINE_DEPTH-1];
    assign mul_out = final_sum;

endmodule