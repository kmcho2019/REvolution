module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers - now 4 stages (16 bits each)
reg [63:0] adda_pipe [0:3];
reg [63:0] addb_pipe [0:3];
reg [3:0] carry_pipe; // Only need to store final carry between stages
reg [63:0] sum_pipe [0:3];
reg [3:0] en_pipe;

// Carry-select adder segments
wire [16:0] sum_stage [0:3];
wire [3:0] carry_out;

// Generate carry-select adders for each stage
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : adder_stages
        assign {carry_out[i], sum_stage[i][15:0]} = 
            adda_pipe[i][(i*16)+15:i*16] + 
            addb_pipe[i][(i*16)+15:i*16] + 
            ((i == 0) ? 1'b0 : carry_pipe[i-1]);
        assign sum_stage[i][16] = carry_out[i]; // Final carry
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < 4; j = j + 1) begin
            adda_pipe[j] <= 64'b0;
            addb_pipe[j] <= 64'b0;
            sum_pipe[j] <= 64'b0;
        end
        carry_pipe <= 4'b0;
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 0: Input registers
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        en_pipe[0] <= i_en;

        // Pipeline stages 1-3
        for (integer j = 1; j < 4; j = j + 1) begin
            adda_pipe[j] <= adda_pipe[j-1];
            addb_pipe[j] <= addb_pipe[j-1];
            en_pipe[j] <= en_pipe[j-1];
        end

        // Store intermediate carries
        carry_pipe <= carry_out;

        // Store sum segments
        for (integer j = 0; j < 4; j = j + 1) begin
            sum_pipe[j][(j*16)+15:j*16] <= sum_stage[j][15:0];
            if (j == 3) begin
                sum_pipe[j][63:48] <= {15'b0, sum_stage[j][16]};
            end
        end

        // Final result assembly
        result <= {sum_stage[3][16],  // Final carry
                 sum_pipe[3][63:48], sum_pipe[2][47:32],
                 sum_pipe[1][31:16], sum_pipe[0][15:0]};

        // Output enable is the last enable in pipeline
        o_en <= en_pipe[3];
    end
end

endmodule