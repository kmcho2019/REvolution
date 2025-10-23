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
reg [31:0] adda_stg1, addb_stg1;
reg carry_stg1;
reg [31:0] sum_stg1;

// Enable pipeline registers
reg en_stg1, en_stg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        adda_stg1 <= 32'b0;
        addb_stg1 <= 32'b0;
        carry_stg1 <= 1'b0;
        sum_stg1 <= 32'b0;
        en_stg1 <= 1'b0;
        en_stg2 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process lower 32 bits
        {carry_stg1, sum_stg1} <= adda[31:0] + addb[31:0];
        adda_stg1 <= adda[63:32];
        addb_stg1 <= addb[63:32];
        en_stg1 <= i_en;
        
        // Stage 2: Process upper 32 bits and final result
        en_stg2 <= en_stg1;
        result <= {1'b0, adda_stg1} + {1'b0, addb_stg1} + carry_stg1;
        result[31:0] <= sum_stg1;
        o_en <= en_stg2;
    end
end

endmodule