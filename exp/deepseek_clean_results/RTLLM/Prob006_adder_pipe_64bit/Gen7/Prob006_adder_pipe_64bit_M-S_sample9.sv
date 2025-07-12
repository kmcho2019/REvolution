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
reg [31:0] adda_hi, addb_hi;
reg [31:0] sum_lo;
reg carry_lo;
reg pipe_en;

// Combinational sums
wire [32:0] sum_lo_full = {1'b0, adda[31:0]} + {1'b0, addb[31:0]};
wire [32:0] sum_hi_full = {1'b0, adda_hi} + {1'b0, addb_hi} + carry_lo;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_hi <= 32'b0;
        addb_hi <= 32'b0;
        sum_lo <= 32'b0;
        carry_lo <= 1'b0;
        pipe_en <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Process lower 32 bits and store upper operands
        sum_lo <= sum_lo_full[31:0];
        carry_lo <= sum_lo_full[32];
        adda_hi <= adda[63:32];
        addb_hi <= addb[63:32];
        pipe_en <= i_en;
        
        // Stage 2: Process upper 32 bits and generate output
        result <= {sum_hi_full[32:0], sum_lo};
        o_en <= pipe_en;
    end
end

endmodule