module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output reg o_en
);

// Pipeline stage 1 (lower 32 bits)
reg [31:0] adda_lo, addb_lo;
reg stage1_en;
wire [32:0] sum_lo = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
reg stage1_carry;

// Pipeline stage 2 (upper 32 bits with carry)
reg [31:0] adda_hi, addb_hi;
reg stage2_en;
wire [32:0] sum_hi = {1'b0, adda_hi} + {1'b0, addb_hi} + stage1_carry;

// Output assignment
assign result = {sum_hi[31:0], sum_lo[31:0]};

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Stage 1 registers
        adda_lo <= 32'b0;
        addb_lo <= 32'b0;
        stage1_carry <= 1'b0;
        stage1_en <= 1'b0;
        
        // Stage 2 registers
        adda_hi <= 32'b0;
        addb_hi <= 32'b0;
        stage2_en <= 1'b0;
        
        // Output register
        o_en <= 1'b0;
    end else begin
        // Stage 1 update
        adda_lo <= adda[31:0];
        addb_lo <= addb[31:0];
        stage1_carry <= sum_lo[32];
        stage1_en <= i_en;
        
        // Stage 2 update
        adda_hi <= adda[63:32];
        addb_hi <= addb[63:32];
        stage2_en <= stage1_en;
        
        // Output update
        o_en <= stage2_en;
    end
end

endmodule