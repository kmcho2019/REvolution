module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [63:0] stage1_a, stage1_b;
reg [7:0] seg_a [7:0];  // 8 segments of 8 bits
reg [7:0] seg_b [7:0];

// Carry-select sums (0 = carry-in 0, 1 = carry-in 1)
reg [8:0] seg_sum0 [7:0];  // 8-bit sum + carry-out
reg [8:0] seg_sum1 [7:0];

// Pipeline control
reg en1, en2, en3;

// Intermediate carries
reg [7:0] carry_chain;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        
        for (integer i = 0; i < 8; i = i + 1) begin
            seg_a[i] <= 8'b0;
            seg_b[i] <= 8'b0;
            seg_sum0[i] <= 9'b0;
            seg_sum1[i] <= 9'b0;
        end
        
        carry_chain <= 8'b0;
        en1 <= 1'b0;
        en2 <= 1'b0;
        en3 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline Stage 1: Input registration and segmentation
        stage1_a <= adda;
        stage1_b <= addb;
        en1 <= i_en;
        
        // Split into 8 segments
        for (integer i = 0; i < 8; i = i + 1) begin
            seg_a[i] <= adda[8*i+7 : 8*i];
            seg_b[i] <= addb[8*i+7 : 8*i];
        end
        
        // Pipeline Stage 2: Parallel sum calculation
        en2 <= en1;
        
        // Calculate both possible sums for each segment
        for (integer i = 0; i < 8; i = i + 1) begin
            seg_sum0[i] <= {1'b0, seg_a[i]} + {1'b0, seg_b[i]};  // carry-in 0
            seg_sum1[i] <= {1'b0, seg_a[i]} + {1'b0, seg_b[i]} + 1'b1;  // carry-in 1
        end
        
        // Pipeline Stage 3: Carry propagation and result assembly
        en3 <= en2;
        o_en <= en3;
        
        if (en3) begin
            // First segment always uses carry-in 0
            result[7:0] <= seg_sum0[0][7:0];
            carry_chain[0] <= seg_sum0[0][8];
            
            // Subsequent segments select based on previous carry
            for (integer i = 1; i < 8; i = i + 1) begin
                if (carry_chain[i-1]) begin
                    result[8*i+7 : 8*i] <= seg_sum1[i][7:0];
                    carry_chain[i] <= seg_sum1[i][8];
                end else begin
                    result[8*i+7 : 8*i] <= seg_sum0[i][7:0];
                    carry_chain[i] <= seg_sum0[i][8];
                end
            end
            
            // Final carry-out
            result[64] <= carry_chain[7];
        end else begin
            result <= 65'b0;
        end
    end
end

endmodule