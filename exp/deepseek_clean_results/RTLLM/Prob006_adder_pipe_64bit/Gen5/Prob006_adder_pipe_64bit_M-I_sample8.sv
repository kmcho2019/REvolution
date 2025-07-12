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
reg [63:0] adda_pipe [7:0];
reg [63:0] addb_pipe [7:0];
reg [7:0] carry_pipe [7:0];
reg [7:0] en_pipe;

// Intermediate sums
wire [8:0] stage_sum [7:0];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pipeline_stages
        // Compute sum for each 8-bit segment (including carry)
        assign stage_sum[i] = {1'b0, adda_pipe[i][7:0]} + {1'b0, addb_pipe[i][7:0]} + carry_pipe[i][0];
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < 8; j = j + 1) begin
            adda_pipe[j] <= 64'b0;
            addb_pipe[j] <= 64'b0;
            carry_pipe[j] <= 8'b0;
        end
        en_pipe <= 8'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Input registration
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        carry_pipe[0] <= 8'b0;  // First stage has no carry-in
        en_pipe[0] <= i_en;

        // Pipeline stages 1-7
        for (integer k = 1; k < 8; k = k + 1) begin
            adda_pipe[k] <= adda_pipe[k-1] >> 8;
            addb_pipe[k] <= addb_pipe[k-1] >> 8;
            // Carry propagation
            carry_pipe[k] <= {7'b0, stage_sum[k-1][8]};
            en_pipe[k] <= en_pipe[k-1];
        end

        // Final result assembly
        result <= {
            stage_sum[7][8],  // Final carry
            stage_sum[7][7:0],
            stage_sum[6][7:0],
            stage_sum[5][7:0],
            stage_sum[4][7:0],
            stage_sum[3][7:0],
            stage_sum[2][7:0],
            stage_sum[1][7:0],
            stage_sum[0][7:0]
        };

        o_en <= en_pipe[7];
    end
end

endmodule