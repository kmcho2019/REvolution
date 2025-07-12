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
reg [63:0] adda_pipe [0:3];
reg [63:0] addb_pipe [0:3];
reg [3:0] carry_pipe;
reg [3:0] en_pipe;

// Intermediate sums (carry=0 and carry=1 cases)
wire [15:0] sum0_0, sum0_1, sum1_0, sum1_1, sum2_0, sum2_1, sum3_0, sum3_1;
wire carry0_0, carry0_1, carry1_0, carry1_1, carry2_0, carry2_1;

// Stage 0: bits [15:0]
assign {carry0_0, sum0_0} = adda[15:0] + addb[15:0];
assign {carry0_1, sum0_1} = adda[15:0] + addb[15:0] + 1'b1;

// Stage 1: bits [31:16]
assign {carry1_0, sum1_0} = adda[31:16] + addb[31:16];
assign {carry1_1, sum1_1} = adda[31:16] + addb[31:16] + 1'b1;

// Stage 2: bits [47:32]
assign {carry2_0, sum2_0} = adda[47:32] + addb[47:32];
assign {carry2_1, sum2_1} = adda[47:32] + addb[47:32] + 1'b1;

// Stage 3: bits [63:48]
assign sum3_0 = adda[63:48] + addb[63:48];
assign sum3_1 = adda[63:48] + addb[63:48] + 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < 4; i = i + 1) begin
            adda_pipe[i] <= 64'b0;
            addb_pipe[i] <= 64'b0;
        end
        carry_pipe <= 4'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Register inputs
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        
        // Pipeline stage 1: Register stage 0 results and select carry
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        carry_pipe[0] <= carry_pipe[0] ? carry0_1 : carry0_0;
        
        // Pipeline stage 2: Register stage 1 results and select carry
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        carry_pipe[1] <= carry_pipe[0] ? carry1_1 : carry1_0;
        
        // Pipeline stage 3: Register stage 2 results and select carry
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        carry_pipe[2] <= carry_pipe[1] ? carry2_1 : carry2_0;
        
        // Final result composition
        result[15:0] <= carry_pipe[0] ? sum0_1 : sum0_0;
        result[31:16] <= carry_pipe[0] ? sum1_1 : sum1_0;
        result[47:32] <= carry_pipe[1] ? sum2_1 : sum2_0;
        result[63:48] <= carry_pipe[2] ? sum3_1 : sum3_0;
        result[64] <= carry_pipe[2] ? (sum3_1 < adda_pipe[3][63:48]) : 
                                     (sum3_0 < adda_pipe[3][63:48]);
        
        // Enable signal pipeline
        en_pipe <= {en_pipe[2:0], i_en};
        o_en <= en_pipe[3];
    end
end

endmodule