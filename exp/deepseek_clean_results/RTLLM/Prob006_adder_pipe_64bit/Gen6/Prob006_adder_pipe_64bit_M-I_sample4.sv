module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] adda_reg1, adda_reg2;
reg [63:0] addb_reg1, addb_reg2;
reg carry_reg;
reg [1:0] en_reg;

// Stage 1 signals
wire [31:0] sum_low;
wire carry_low;

// Stage 2 signals
wire [31:0] sum_high;
wire carry_high;

// First stage: lower 32 bits
assign {carry_low, sum_low} = adda[31:0] + addb[31:0];

// Second stage: upper 32 bits with carry
assign {carry_high, sum_high} = adda_reg1[63:32] + addb_reg1[63:32] + carry_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        adda_reg1 <= 64'b0;
        adda_reg2 <= 64'b0;
        addb_reg1 <= 64'b0;
        addb_reg2 <= 64'b0;
        carry_reg <= 1'b0;
        en_reg <= 2'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1: register inputs and compute lower 32 bits
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        carry_reg <= carry_low;
        
        // Pipeline stage 2: register upper 32 bits and carry
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        
        // Final result composition
        result <= {carry_high, sum_high, sum_low};
        
        // Enable signal pipeline
        en_reg <= {en_reg[0], i_en};
        o_en <= en_reg[1];
    end
end

endmodule