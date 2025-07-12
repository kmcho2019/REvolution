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
reg [7:0] adda_pipe [7:0];
reg [7:0] addb_pipe [7:0];
reg [8:0] sum0_pipe [7:0];  // Sum assuming carry-in=0
reg [8:0] sum1_pipe [7:0];  // Sum assuming carry-in=1
reg carry_pipe [7:0];
reg en_pipe [7:0];

// Intermediate wires
wire [8:0] sum0 [7:0];  // Sum with carry=0
wire [8:0] sum1 [7:0];  // Sum with carry=1

// Generate carry-select adders for each segment
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : adder_segments
        // Compute both possible sums for each segment
        assign sum0[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]};
        assign sum1[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + 1'b1;
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < 8; j = j + 1) begin
            adda_pipe[j] <= 8'b0;
            addb_pipe[j] <= 8'b0;
            sum0_pipe[j] <= 9'b0;
            sum1_pipe[j] <= 9'b0;
            carry_pipe[j] <= 1'b0;
            en_pipe[j] <= 1'b0;
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 0: Input registration
        adda_pipe[0] <= adda[7:0];
        addb_pipe[0] <= addb[7:0];
        carry_pipe[0] <= 1'b0;  // First segment has no carry-in
        en_pipe[0] <= i_en;

        // Pipeline stages 1-7
        for (integer k = 1; k < 8; k = k + 1) begin
            adda_pipe[k] <= adda[8*k+7 : 8*k];
            addb_pipe[k] <= addb[8*k+7 : 8*k];
            // Carry selection from previous stage
            carry_pipe[k] <= carry_pipe[k-1] ? sum1_pipe[k-1][8] : sum0_pipe[k-1][8];
            en_pipe[k] <= en_pipe[k-1];
            
            // Store both possible sums for next stage's carry selection
            sum0_pipe[k-1] <= sum0[k-1];
            sum1_pipe[k-1] <= sum1[k-1];
        end

        // Store final segment's sums
        sum0_pipe[7] <= sum0[7];
        sum1_pipe[7] <= sum1[7];

        // Final result assembly
        result <= {
            carry_pipe[7] ? sum1_pipe[7][8] : sum0_pipe[7][8],  // Final carry
            carry_pipe[7] ? sum1_pipe[7][7:0] : sum0_pipe[7][7:0],
            carry_pipe[6] ? sum1_pipe[6][7:0] : sum0_pipe[6][7:0],
            carry_pipe[5] ? sum1_pipe[5][7:0] : sum0_pipe[5][7:0],
            carry_pipe[4] ? sum1_pipe[4][7:0] : sum0_pipe[4][7:0],
            carry_pipe[3] ? sum1_pipe[3][7:0] : sum0_pipe[3][7:0],
            carry_pipe[2] ? sum1_pipe[2][7:0] : sum0_pipe[2][7:0],
            carry_pipe[1] ? sum1_pipe[1][7:0] : sum0_pipe[1][7:0],
            carry_pipe[0] ? sum1_pipe[0][7:0] : sum0_pipe[0][7:0]
        };

        o_en <= en_pipe[7];
    end
end

endmodule