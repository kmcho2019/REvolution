module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [15:0] a_stg1 [0:3];
reg [15:0] b_stg1 [0:3];
reg [15:0] a_stg2 [0:3];
reg [15:0] b_stg2 [0:3];
reg [15:0] a_stg3 [0:3];
reg [15:0] b_stg3 [0:3];

// Carry-select computation
wire [16:0] sum0 [0:3];  // Sum with carry=0
wire [16:0] sum1 [0:3];  // Sum with carry=1
reg [16:0] sum_reg [0:3];
reg [3:0] carry_chain;

// Enable pipeline
reg [3:0] en_pipeline;

// Generate partial sums (carry-select)
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : gen_sums
        assign sum0[i] = {1'b0, a_stg3[i]} + {1'b0, b_stg3[i]};
        assign sum1[i] = {1'b0, a_stg3[i]} + {1'b0, b_stg3[i]} + 17'b1;
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline stages
        for (integer j = 0; j < 4; j = j + 1) begin
            a_stg1[j] <= 16'b0;
            b_stg1[j] <= 16'b0;
            a_stg2[j] <= 16'b0;
            b_stg2[j] <= 16'b0;
            a_stg3[j] <= 16'b0;
            b_stg3[j] <= 16'b0;
            sum_reg[j] <= 17'b0;
        end
        carry_chain <= 4'b0;
        en_pipeline <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Input sampling and chunking
        for (integer k = 0; k < 4; k = k + 1) begin
            a_stg1[k] <= adda[16*k+15 : 16*k];
            b_stg1[k] <= addb[16*k+15 : 16*k];
        end

        // Stage 2: First pipeline registers
        for (integer k = 0; k < 4; k = k + 1) begin
            a_stg2[k] <= a_stg1[k];
            b_stg2[k] <= b_stg1[k];
        end

        // Stage 3: Second pipeline registers
        for (integer k = 0; k < 4; k = k + 1) begin
            a_stg3[k] <= a_stg2[k];
            b_stg3[k] <= b_stg2[k];
        end

        // Stage 4: Carry-select and final sum
        carry_chain[0] <= 1'b0;  // No carry in for first block
        for (integer m = 0; m < 4; m = m + 1) begin
            sum_reg[m] <= carry_chain[m] ? sum1[m] : sum0[m];
            if (m < 3) carry_chain[m+1] <= sum_reg[m][16];
        end

        // Final result assembly
        result <= {sum_reg[3][16:1], sum_reg[3][0], 
                  sum_reg[2][15:0], 
                  sum_reg[1][15:0], 
                  sum_reg[0][15:0]};

        // Enable signal pipeline
        en_pipeline <= {en_pipeline[2:0], i_en};
        o_en <= en_pipeline[3];
    end
end

endmodule