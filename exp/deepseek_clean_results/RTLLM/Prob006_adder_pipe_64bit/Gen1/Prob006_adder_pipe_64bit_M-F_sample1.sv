module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

localparam NUM_STAGES = DATA_WIDTH/STG_WIDTH;

// Pipeline registers
reg [STG_WIDTH-1:0] adda_stage1, addb_stage1;
reg [STG_WIDTH-1:0] adda_stage2, addb_stage2;
reg [STG_WIDTH-1:0] adda_stage3, addb_stage3;
reg [STG_WIDTH-1:0] adda_stage4, addb_stage4;

reg [STG_WIDTH:0] sum_stage1;
reg [STG_WIDTH:0] sum_stage2;
reg [STG_WIDTH:0] sum_stage3;
reg [STG_WIDTH:0] sum_stage4;

reg carry_stage1;
reg carry_stage2;
reg carry_stage3;

// Enable signal pipeline
reg en_stage1;
reg en_stage2;
reg en_stage3;
reg en_stage4;

// Combinational additions for each stage
wire [STG_WIDTH:0] sum1 = adda_stage1 + addb_stage1;
wire [STG_WIDTH:0] sum2 = {1'b0, adda_stage2} + {1'b0, addb_stage2} + carry_stage1;
wire [STG_WIDTH:0] sum3 = {1'b0, adda_stage3} + {1'b0, addb_stage3} + carry_stage2;
wire [STG_WIDTH:0] sum4 = {1'b0, adda_stage4} + {1'b0, addb_stage4} + carry_stage3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_stage1 <= {STG_WIDTH{1'b0}};
        addb_stage1 <= {STG_WIDTH{1'b0}};
        adda_stage2 <= {STG_WIDTH{1'b0}};
        addb_stage2 <= {STG_WIDTH{1'b0}};
        adda_stage3 <= {STG_WIDTH{1'b0}};
        addb_stage3 <= {STG_WIDTH{1'b0}};
        adda_stage4 <= {STG_WIDTH{1'b0}};
        addb_stage4 <= {STG_WIDTH{1'b0}};
        
        sum_stage1 <= {(STG_WIDTH+1){1'b0}};
        sum_stage2 <= {(STG_WIDTH+1){1'b0}};
        sum_stage3 <= {(STG_WIDTH+1){1'b0}};
        sum_stage4 <= {(STG_WIDTH+1){1'b0}};
        
        carry_stage1 <= 1'b0;
        carry_stage2 <= 1'b0;
        carry_stage3 <= 1'b0;
        
        en_stage1 <= 1'b0;
        en_stage2 <= 1'b0;
        en_stage3 <= 1'b0;
        en_stage4 <= 1'b0;
        
        result <= {(DATA_WIDTH+1){1'b0}};
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process bits [STG_WIDTH-1:0]
        adda_stage1 <= adda[STG_WIDTH-1:0];
        addb_stage1 <= addb[STG_WIDTH-1:0];
        sum_stage1 <= sum1;
        carry_stage1 <= sum1[STG_WIDTH];
        en_stage1 <= i_en;
        
        // Stage 2: Process bits [2*STG_WIDTH-1:STG_WIDTH]
        adda_stage2 <= adda[2*STG_WIDTH-1:STG_WIDTH];
        addb_stage2 <= addb[2*STG_WIDTH-1:STG_WIDTH];
        sum_stage2 <= sum2;
        carry_stage2 <= sum2[STG_WIDTH];
        en_stage2 <= en_stage1;
        
        // Stage 3: Process bits [3*STG_WIDTH-1:2*STG_WIDTH]
        adda_stage3 <= adda[3*STG_WIDTH-1:2*STG_WIDTH];
        addb_stage3 <= addb[3*STG_WIDTH-1:2*STG_WIDTH];
        sum_stage3 <= sum3;
        carry_stage3 <= sum3[STG_WIDTH];
        en_stage3 <= en_stage2;
        
        // Stage 4: Process bits [4*STG_WIDTH-1:3*STG_WIDTH]
        adda_stage4 <= adda[4*STG_WIDTH-1:3*STG_WIDTH];
        addb_stage4 <= addb[4*STG_WIDTH-1:3*STG_WIDTH];
        sum_stage4 <= sum4;
        en_stage4 <= en_stage3;
        
        // Final result assembly
        result <= {sum4[STG_WIDTH-1:0], sum3[STG_WIDTH-1:0], 
                  sum2[STG_WIDTH-1:0], sum1[STG_WIDTH-1:0]};
        o_en <= en_stage4;
    end
end

endmodule