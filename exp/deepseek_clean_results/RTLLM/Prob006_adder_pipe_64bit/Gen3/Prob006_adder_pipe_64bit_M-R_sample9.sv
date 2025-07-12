module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters for pipeline configuration
parameter STAGES = 4;
parameter BITS_PER_STAGE = 16;

// Pipeline registers - stage 0
reg [BITS_PER_STAGE-1:0] adda_0;
reg [BITS_PER_STAGE-1:0] addb_0;
reg carry_0;
reg [BITS_PER_STAGE-1:0] sum_0;

// Pipeline registers - stage 1
reg [BITS_PER_STAGE-1:0] adda_1;
reg [BITS_PER_STAGE-1:0] addb_1;
reg carry_1;
reg [BITS_PER_STAGE-1:0] sum_1;

// Pipeline registers - stage 2
reg [BITS_PER_STAGE-1:0] adda_2;
reg [BITS_PER_STAGE-1:0] addb_2;
reg carry_2;
reg [BITS_PER_STAGE-1:0] sum_2;

// Pipeline registers - stage 3
reg [BITS_PER_STAGE-1:0] adda_3;
reg [BITS_PER_STAGE-1:0] addb_3;
reg carry_3;
reg [BITS_PER_STAGE-1:0] sum_3;

// Enable signal pipeline
reg [STAGES-1:0] en_pipe;

// Adder outputs
wire [BITS_PER_STAGE:0] sum_out_0; // {carry, sum}
wire [BITS_PER_STAGE:0] sum_out_1;
wire [BITS_PER_STAGE:0] sum_out_2;
wire [BITS_PER_STAGE:0] sum_out_3;

// Stage 0 adder (no carry in)
assign sum_out_0 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};

// Stage 1 adder (carry from stage 0)
assign sum_out_1 = {1'b0, adda_0} + {1'b0, addb_0} + carry_0;

// Stage 2 adder (carry from stage 1)
assign sum_out_2 = {1'b0, adda_1} + {1'b0, addb_1} + carry_1;

// Stage 3 adder (carry from stage 2)
assign sum_out_3 = {1'b0, adda_2} + {1'b0, addb_2} + carry_2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_0 <= 0; addb_0 <= 0; carry_0 <= 0; sum_0 <= 0;
        adda_1 <= 0; addb_1 <= 0; carry_1 <= 0; sum_1 <= 0;
        adda_2 <= 0; addb_2 <= 0; carry_2 <= 0; sum_2 <= 0;
        adda_3 <= 0; addb_3 <= 0; carry_3 <= 0; sum_3 <= 0;
        en_pipe <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Pipeline stage 0
        adda_0 <= adda[15:0];
        addb_0 <= addb[15:0];
        carry_0 <= sum_out_0[16];
        sum_0 <= sum_out_0[15:0];
        
        // Pipeline stage 1
        adda_1 <= adda[31:16];
        addb_1 <= addb[31:16];
        carry_1 <= sum_out_1[16];
        sum_1 <= sum_out_1[15:0];
        
        // Pipeline stage 2
        adda_2 <= adda[47:32];
        addb_2 <= addb[47:32];
        carry_2 <= sum_out_2[16];
        sum_2 <= sum_out_2[15:0];
        
        // Pipeline stage 3
        adda_3 <= adda[63:48];
        addb_3 <= addb[63:48];
        carry_3 <= sum_out_3[16];
        sum_3 <= sum_out_3[15:0];
        
        // Enable signal pipeline
        en_pipe <= {en_pipe[STAGES-2:0], i_en};
        
        // Final result assembly
        result <= {carry_3, sum_3, sum_2, sum_1, sum_0};
        
        // Output enable
        o_en <= en_pipe[STAGES-1];
    end
end

endmodule