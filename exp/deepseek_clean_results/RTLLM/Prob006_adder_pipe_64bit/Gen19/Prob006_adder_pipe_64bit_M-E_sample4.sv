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
reg [15:0] adda_stg1, addb_stg1;
reg [15:0] adda_stg2, addb_stg2;
reg [15:0] adda_stg3, addb_stg3;
reg [15:0] adda_stg4, addb_stg4;

reg [3:0] en_pipeline;
reg carry_stg1, carry_stg2, carry_stg3;

// Stage 1: Bits [15:0]
wire [16:0] sum_stg1_0 = {1'b0, adda_stg1} + {1'b0, addb_stg1};
wire [16:0] sum_stg1_1 = {1'b0, adda_stg1} + {1'b0, addb_stg1} + 1'b1;

// Stage 2: Bits [31:16]
wire [16:0] sum_stg2_0 = {1'b0, adda_stg2} + {1'b0, addb_stg2};
wire [16:0] sum_stg2_1 = {1'b0, adda_stg2} + {1'b0, addb_stg2} + 1'b1;
wire [15:0] res_stg2 = carry_stg1 ? sum_stg2_1[15:0] : sum_stg2_0[15:0];
wire carry_stg2_next = carry_stg1 ? sum_stg2_1[16] : sum_stg2_0[16];

// Stage 3: Bits [47:32]
wire [16:0] sum_stg3_0 = {1'b0, adda_stg3} + {1'b0, addb_stg3};
wire [16:0] sum_stg3_1 = {1'b0, adda_stg3} + {1'b0, addb_stg3} + 1'b1;
wire [15:0] res_stg3 = carry_stg2 ? sum_stg3_1[15:0] : sum_stg3_0[15:0];
wire carry_stg3_next = carry_stg2 ? sum_stg3_1[16] : sum_stg3_0[16];

// Stage 4: Bits [63:48]
wire [16:0] sum_stg4_0 = {1'b0, adda_stg4} + {1'b0, addb_stg4};
wire [16:0] sum_stg4_1 = {1'b0, adda_stg4} + {1'b0, addb_stg4} + 1'b1;
wire [15:0] res_stg4 = carry_stg3 ? sum_stg4_1[15:0] : sum_stg4_0[15:0];
wire carry_out = carry_stg3 ? sum_stg4_1[16] : sum_stg4_0[16];

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Stage 1 registers
        adda_stg1 <= 16'b0;
        addb_stg1 <= 16'b0;
        carry_stg1 <= 1'b0;
        
        // Stage 2 registers
        adda_stg2 <= 16'b0;
        addb_stg2 <= 16'b0;
        carry_stg2 <= 1'b0;
        
        // Stage 3 registers
        adda_stg3 <= 16'b0;
        addb_stg3 <= 16'b0;
        carry_stg3 <= 1'b0;
        
        // Stage 4 registers
        adda_stg4 <= 16'b0;
        addb_stg4 <= 16'b0;
        
        // Enable pipeline
        en_pipeline <= 4'b0;
        
        // Output registers
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Capture inputs and compute first sum
        adda_stg1 <= adda[15:0];
        addb_stg1 <= addb[15:0];
        carry_stg1 <= sum_stg1_0[16]; // Default carry (will be overwritten if needed)
        
        // Stage 2: Capture next segment and resolve carry
        adda_stg2 <= adda[31:16];
        addb_stg2 <= addb[31:16];
        carry_stg2 <= carry_stg2_next;
        
        // Stage 3: Capture next segment and resolve carry
        adda_stg3 <= adda[47:32];
        addb_stg3 <= addb[47:32];
        carry_stg3 <= carry_stg3_next;
        
        // Stage 4: Capture final segment
        adda_stg4 <= adda[63:48];
        addb_stg4 <= addb[63:48];
        
        // Pipeline the enable signal
        en_pipeline <= {en_pipeline[2:0], i_en};
        
        // Output result and enable
        result <= {carry_out, res_stg4, res_stg3, res_stg2, sum_stg1_0[15:0]};
        o_en <= en_pipeline[3];
    end
end

endmodule