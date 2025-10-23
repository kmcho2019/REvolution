module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Constants
localparam STAGES = 4;
localparam BITS_PER_STAGE = 16;

// Pipeline registers
reg [63:0] a_pipe [0:STAGES-1];
reg [63:0] b_pipe [0:STAGES-1];
reg [STAGES-1:0] en_pipe;
reg [15:0] sum [0:STAGES-1];
reg carry [0:STAGES];

// Combinational addition for each stage
wire [16:0] stage_sum [0:STAGES-1];

// Stage 0: Bits 15:0
assign stage_sum[0] = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

// Stage 1: Bits 31:16 with carry from stage 0
assign stage_sum[1] = {1'b0, a_pipe[0][31:16]} + {1'b0, b_pipe[0][31:16]} + carry[0];

// Stage 2: Bits 47:32 with carry from stage 1
assign stage_sum[2] = {1'b0, a_pipe[1][47:32]} + {1'b0, b_pipe[1][47:32]} + carry[1];

// Stage 3: Bits 63:48 with carry from stage 2
assign stage_sum[3] = {1'b0, a_pipe[2][63:48]} + {1'b0, b_pipe[2][63:48]} + carry[2];

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer i = 0; i < STAGES; i = i + 1) begin
            a_pipe[i] <= 64'b0;
            b_pipe[i] <= 64'b0;
            sum[i] <= 16'b0;
            carry[i] <= 1'b0;
        end
        carry[STAGES] <= 1'b0;
        en_pipe <= {STAGES{1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline propagation
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        sum[0] <= stage_sum[0][15:0];
        carry[0] <= stage_sum[0][16];
        
        for (integer i = 1; i < STAGES; i = i + 1) begin
            a_pipe[i] <= a_pipe[i-1];
            b_pipe[i] <= b_pipe[i-1];
            sum[i] <= stage_sum[i][15:0];
            carry[i] <= stage_sum[i][16];
        end
        
        // Final carry
        carry[STAGES] <= carry[STAGES-1];
        
        // Enable signal propagation
        en_pipe <= {en_pipe[STAGES-2:0], i_en};
        
        // Output assembly
        if (en_pipe[STAGES-1]) begin
            result <= {carry[STAGES], 
                      sum[3], sum[2], sum[1], sum[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule