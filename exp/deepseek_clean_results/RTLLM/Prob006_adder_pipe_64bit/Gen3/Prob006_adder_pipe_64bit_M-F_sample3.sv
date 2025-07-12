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

reg carry_stg1, carry_stg2, carry_stg3;
reg [15:0] sum_stg1, sum_stg2, sum_stg3;

// Enable pipeline registers
reg en_stg1, en_stg2, en_stg3, en_stg4;

// Combinational additions for each stage
wire [16:0] sum1 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
wire [16:0] sum2 = {1'b0, adda_stg1} + {1'b0, addb_stg1} + carry_stg1;
wire [16:0] sum3 = {1'b0, adda_stg2} + {1'b0, addb_stg2} + carry_stg2;
wire [16:0] sum4 = {1'b0, adda_stg3} + {1'b0, addb_stg3} + carry_stg3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_stg1 <= 16'b0; addb_stg1 <= 16'b0;
        adda_stg2 <= 16'b0; addb_stg2 <= 16'b0;
        adda_stg3 <= 16'b0; addb_stg3 <= 16'b0;
        adda_stg4 <= 16'b0; addb_stg4 <= 16'b0;
        
        carry_stg1 <= 1'b0; carry_stg2 <= 1'b0; carry_stg3 <= 1'b0;
        sum_stg1 <= 16'b0; sum_stg2 <= 16'b0; sum_stg3 <= 16'b0;
        
        en_stg1 <= 1'b0; en_stg2 <= 1'b0; en_stg3 <= 1'b0; en_stg4 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process bits 0-15
        adda_stg1 <= adda[31:16];
        addb_stg1 <= addb[31:16];
        carry_stg1 <= sum1[16];
        sum_stg1 <= sum1[15:0];
        en_stg1 <= i_en;
        
        // Stage 2: Process bits 16-31
        adda_stg2 <= adda[47:32];
        addb_stg2 <= addb[47:32];
        carry_stg2 <= sum2[16];
        sum_stg2 <= sum2[15:0];
        en_stg2 <= en_stg1;
        
        // Stage 3: Process bits 32-47
        adda_stg3 <= adda[63:48];
        addb_stg3 <= addb[63:48];
        carry_stg3 <= sum3[16];
        sum_stg3 <= sum3[15:0];
        en_stg3 <= en_stg2;
        
        // Stage 4: Process bits 48-63 and final result
        adda_stg4 <= 16'b0; // Not used, just for pipeline alignment
        addb_stg4 <= 16'b0; // Not used, just for pipeline alignment
        en_stg4 <= en_stg3;
        
        // Final result assembly
        result <= {sum4[16], sum_stg3, sum_stg2, sum_stg1, sum1[15:0]};
        o_en <= en_stg4;
    end
end

endmodule