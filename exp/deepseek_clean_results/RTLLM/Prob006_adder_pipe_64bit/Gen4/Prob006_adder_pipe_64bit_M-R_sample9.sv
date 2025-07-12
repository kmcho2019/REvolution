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
reg [15:0] adda_16_31, addb_16_31;
reg [15:0] adda_32_47, addb_32_47;
reg [15:0] adda_48_63, addb_48_63;

reg carry_16_31, carry_32_47, carry_48_63;
reg [15:0] sum_0_15, sum_16_31, sum_32_47;

// Enable signal pipeline
reg en_stg1, en_stg2, en_stg3, en_stg4;

// Combinational additions
wire [16:0] sum_stg1 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
wire [16:0] sum_stg2 = {1'b0, adda_16_31} + {1'b0, addb_16_31} + carry_16_31;
wire [16:0] sum_stg3 = {1'b0, adda_32_47} + {1'b0, addb_32_47} + carry_32_47;
wire [16:0] sum_stg4 = {1'b0, adda_48_63} + {1'b0, addb_48_63} + carry_48_63;

// Pipeline stage 1: bits 0-15
assign sum_0_15 = sum_stg1[15:0];

// Pipeline stage 2: bits 16-31
assign sum_16_31 = sum_stg2[15:0];

// Pipeline stage 3: bits 32-47
assign sum_32_47 = sum_stg3[15:0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_16_31 <= 16'b0; addb_16_31 <= 16'b0;
        adda_32_47 <= 16'b0; addb_32_47 <= 16'b0;
        adda_48_63 <= 16'b0; addb_48_63 <= 16'b0;
        
        carry_16_31 <= 1'b0; carry_32_47 <= 1'b0; carry_48_63 <= 1'b0;
        
        en_stg1 <= 1'b0; en_stg2 <= 1'b0; en_stg3 <= 1'b0; en_stg4 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1 registers
        adda_16_31 <= adda[31:16];
        addb_16_31 <= addb[31:16];
        carry_16_31 <= sum_stg1[16];
        en_stg1 <= i_en;
        
        // Stage 2 registers
        adda_32_47 <= adda[47:32];
        addb_32_47 <= addb[47:32];
        carry_32_47 <= sum_stg2[16];
        en_stg2 <= en_stg1;
        
        // Stage 3 registers
        adda_48_63 <= adda[63:48];
        addb_48_63 <= addb[63:48];
        carry_48_63 <= sum_stg3[16];
        en_stg3 <= en_stg2;
        
        // Stage 4 (final result)
        en_stg4 <= en_stg3;
        result <= {sum_stg4[16], sum_32_47, sum_16_31, sum_0_15};
        o_en <= en_stg4;
    end
end

endmodule