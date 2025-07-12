module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

// Define parameters
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 8;

// Calculate chunk size based on data width and stages
parameter CHUNK_SIZE = DATA_WIDTH / STG_WIDTH;

// Define wires and registers
reg [CHUNK_SIZE-1:0] adda_regs [STG_WIDTH-1:0];
reg [CHUNK_SIZE-1:0] addb_regs [STG_WIDTH-1:0];
reg [CHUNK_SIZE:0] partial_sums [STG_WIDTH-1:0];
reg [DATA_WIDTH+1:0] result_reg;
reg o_en_reg;

// Input registers and pipeline stages
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < STG_WIDTH; i++) begin
            adda_regs[i] <= 0;
            addb_regs[i] <= 0;
            partial_sums[i] <= 0;
        end
        result_reg <= 0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_regs[0] <= adda[CHUNK_SIZE-1:0];
        addb_regs[0] <= addb[CHUNK_SIZE-1:0];
        for (int i = 1; i < STG_WIDTH; i++) begin
            adda_regs[i] <= adda[(i*CHUNK_SIZE)+:CHUNK_SIZE];
            addb_regs[i] <= addb[(i*CHUNK_SIZE)+:CHUNK_SIZE];
        end
        partial_sums[0] <= {1'b0, adda_regs[0]} + {1'b0, addb_regs[0]};
        for (int i = 1; i < STG_WIDTH; i++) begin
            partial_sums[i] <= {partial_sums[i-1][CHUNK_SIZE], adda_regs[i]} + {partial_sums[i-1][CHUNK_SIZE], addb_regs[i]};
        end
        result_reg <= {partial_sums[STG_WIDTH-1][CHUNK_SIZE], partial_sums[STG_WIDTH-1][CHUNK_SIZE-1:0]};
        o_en_reg <= (partial_sums[STG_WIDTH-1][CHUNK_SIZE] == 1'b1);
    end else begin
        // Hold previous values when i_en is 0
        for (int i = 0; i < STG_WIDTH; i++) begin
            adda_regs[i] <= adda_regs[i];
            addb_regs[i] <= addb_regs[i];
            partial_sums[i] <= partial_sums[i];
        end
        result_reg <= result_reg;
        o_en_reg <= o_en_reg;
    end
end

// Output assignments
assign result = result_reg;
assign o_en = o_en_reg;

endmodule