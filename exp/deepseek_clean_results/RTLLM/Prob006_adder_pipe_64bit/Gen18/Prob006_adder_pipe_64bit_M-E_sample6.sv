module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage parameters
localparam STAGE0_WIDTH = 16;
localparam STAGE1_WIDTH = 16;
localparam STAGE2_WIDTH = 16;
localparam STAGE3_WIDTH = 16;

// Pipeline registers
reg [63:0] a_pipe [0:3];
reg [63:0] b_pipe [0:3];
reg [3:0] en_pipe;
reg [0:3] carry_in;

// Carry-select computation wires
wire [STAGE0_WIDTH:0] sum0_c0, sum0_c1;
wire [STAGE1_WIDTH:0] sum1_c0, sum1_c1;
wire [STAGE2_WIDTH:0] sum2_c0, sum2_c1;
wire [STAGE3_WIDTH:0] sum3_c0, sum3_c1;

// Stage 0 computation (bits 0-15)
assign sum0_c0 = {1'b0, adda[0 +: STAGE0_WIDTH]} + {1'b0, addb[0 +: STAGE0_WIDTH]};
assign sum0_c1 = sum0_c0 + 1'b1;

// Stage 1 computation (bits 16-31)
assign sum1_c0 = {1'b0, a_pipe[0][16 +: STAGE1_WIDTH]} + {1'b0, b_pipe[0][16 +: STAGE1_WIDTH]};
assign sum1_c1 = sum1_c0 + 1'b1;

// Stage 2 computation (bits 32-47)
assign sum2_c0 = {1'b0, a_pipe[1][32 +: STAGE2_WIDTH]} + {1'b0, b_pipe[1][32 +: STAGE2_WIDTH]};
assign sum2_c1 = sum2_c0 + 1'b1;

// Stage 3 computation (bits 48-63)
assign sum3_c0 = {1'b0, a_pipe[2][48 +: STAGE3_WIDTH]} + {1'b0, b_pipe[2][48 +: STAGE3_WIDTH]};
assign sum3_c1 = sum3_c0 + 1'b1;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer i = 0; i < 4; i = i + 1) begin
            a_pipe[i] <= 64'b0;
            b_pipe[i] <= 64'b0;
        end
        en_pipe <= 4'b0;
        carry_in <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[2:0], i_en};
        
        // Stage 0: Register inputs and compute carry0
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_in[0] <= 1'b0;  // Initial carry-in
        
        // Stage 1: Select sum based on carry0 and compute carry1
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        carry_in[1] <= carry_in[0] ? sum0_c1[STAGE0_WIDTH] : sum0_c0[STAGE0_WIDTH];
        
        // Stage 2: Select sum based on carry1 and compute carry2
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        carry_in[2] <= carry_in[1] ? 
                      sum1_c1[STAGE1_WIDTH] : sum1_c0[STAGE1_WIDTH];
        
        // Stage 3: Select sum based on carry2 and compute carry3
        a_pipe[3] <= a_pipe[2];
        b_pipe[3] <= b_pipe[2];
        carry_in[3] <= carry_in[2] ? 
                      sum2_c1[STAGE2_WIDTH] : sum2_c0[STAGE2_WIDTH];
        
        // Output stage
        if (en_pipe[3]) begin
            // Assemble final result with carry-select
            result[63:0] <= {
                carry_in[2] ? sum3_c1[STAGE3_WIDTH-1:0] : sum3_c0[STAGE3_WIDTH-1:0],
                carry_in[1] ? sum2_c1[STAGE2_WIDTH-1:0] : sum2_c0[STAGE2_WIDTH-1:0],
                carry_in[0] ? sum1_c1[STAGE1_WIDTH-1:0] : sum1_c0[STAGE1_WIDTH-1:0],
                sum0_c0[STAGE0_WIDTH-1:0]
            };
            result[64] <= carry_in[3] ? sum3_c1[STAGE3_WIDTH] : sum3_c0[STAGE3_WIDTH];
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule