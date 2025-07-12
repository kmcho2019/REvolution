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
reg [63:0] stage1_a, stage1_b;
reg [3:0][16:0] sum0_0, sum0_1; // 4x17-bit sums (with carry=0 and carry=1)
reg [3:0] carry_prop;           // Carry propagation between blocks
reg [2:0] en_pipe;

// Stage 1: Compute all possible sums in parallel
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        sum0_0 <= {4{17'b0}};
        sum0_1 <= {4{17'b0}};
        en_pipe <= 3'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en_pipe <= {en_pipe[1:0], i_en};
        
        // Compute all block sums with carry=0 and carry=1
        for (integer i = 0; i < 4; i = i + 1) begin
            sum0_0[i] <= {1'b0, adda[i*16 +:16]} + {1'b0, addb[i*16 +:16]};
            sum0_1[i] <= {1'b0, adda[i*16 +:16]} + {1'b0, addb[i*16 +:16]} + 1'b1;
        end
    end
end

// Stage 2: Carry propagation and sum selection
reg [3:0][15:0] selected_sums;
reg final_carry;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        carry_prop <= 4'b0;
        selected_sums <= {4{16'b0}};
        final_carry <= 1'b0;
    end else begin
        // First block always uses carry=0
        carry_prop[0] <= sum0_0[0][16];
        selected_sums[0] <= sum0_0[0][15:0];
        
        // Subsequent blocks select based on previous carry
        for (integer i = 1; i < 4; i = i + 1) begin
            carry_prop[i] <= carry_prop[i-1] ? sum0_1[i][16] : sum0_0[i][16];
            selected_sums[i] <= carry_prop[i-1] ? sum0_1[i][15:0] : sum0_0[i][15:0];
        end
        
        final_carry <= carry_prop[3];
    end
end

// Stage 3: Result assembly
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {final_carry, selected_sums[3], selected_sums[2], 
                  selected_sums[1], selected_sums[0]};
        o_en <= en_pipe[2];
    end
end

endmodule