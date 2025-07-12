module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers (3 stages with 21-bit chunks)
reg [20:0] adda_stg1, addb_stg1;
reg [20:0] adda_stg2, addb_stg2;

reg carry_stg1, carry_stg2;
reg [20:0] sum_stg1, sum_stg2;

// Enable pipeline registers
reg en_stg1, en_stg2, en_stg3;

// Combinational additions for each stage
wire [21:0] sum1 = {1'b0, adda[20:0]} + {1'b0, addb[20:0]};
wire [21:0] sum2 = {1'b0, adda_stg1} + {1'b0, addb_stg1} + carry_stg1;
wire [21:0] sum3 = {1'b0, adda_stg2} + {1'b0, addb_stg2} + carry_stg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        adda_stg1 <= 21'b0; addb_stg1 <= 21'b0;
        adda_stg2 <= 21'b0; addb_stg2 <= 21'b0;
        
        carry_stg1 <= 1'b0; carry_stg2 <= 1'b0;
        sum_stg1 <= 21'b0; sum_stg2 <= 21'b0;
        
        en_stg1 <= 1'b0; en_stg2 <= 1'b0; en_stg3 <= 1'b0;
        
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process bits 0-20
        adda_stg1 <= adda[41:21];
        addb_stg1 <= addb[41:21];
        carry_stg1 <= sum1[21];
        sum_stg1 <= sum1[20:0];
        en_stg1 <= i_en;
        
        // Stage 2: Process bits 21-41
        adda_stg2 <= adda[62:42];
        addb_stg2 <= addb[62:42];
        carry_stg2 <= sum2[21];
        sum_stg2 <= sum2[20:0];
        en_stg2 <= en_stg1;
        
        // Stage 3: Process bits 42-62 and final carry
        en_stg3 <= en_stg2;
        
        // Final result assembly (handles remaining bits and carries)
        result <= {sum3[21], sum_stg2[20:0], sum_stg1[20:0], sum1[20:0]};
        o_en <= en_stg3;
    end
end

endmodule