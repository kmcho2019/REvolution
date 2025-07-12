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
reg [7:0] sum_stage [0:3];  // 4 pipeline stages (8 bits each)
reg carry_stage [0:3];      // Carry for each stage
reg [3:0] en_pipe;          // Enable pipeline

// Internal signals
wire [7:0] sum [0:7];       // 8 segments of 8 bits
wire carry [0:7];           // Carry between segments
wire skip [0:7];            // Carry-skip conditions

// Generate carry-skip segments
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : segment
        // Current 8-bit segment
        wire [7:0] a_seg = adda[8*i+7 : 8*i];
        wire [7:0] b_seg = addb[8*i+7 : 8*i];
        
        // Carry-skip condition (all bits propagate)
        assign skip[i] = &(a_seg ~^ b_seg);
        
        if (i == 0) begin
            // First segment uses 0 as carry-in
            assign {carry[i], sum[i]} = a_seg + b_seg + 1'b0;
        end else begin
            // Subsequent segments use carry from previous segment
            assign {carry[i], sum[i]} = a_seg + b_seg + carry[i-1];
        end
    end
endgenerate

// Carry-skip logic
wire [7:0] carry_skip;
assign carry_skip[0] = carry[0];
assign carry_skip[1] = skip[0] ? carry[1] : carry_skip[0];
assign carry_skip[2] = skip[1] ? carry[2] : carry_skip[1];
assign carry_skip[3] = skip[2] ? carry[3] : carry_skip[2];
assign carry_skip[4] = skip[3] ? carry[4] : carry_skip[3];
assign carry_skip[5] = skip[4] ? carry[5] : carry_skip[4];
assign carry_skip[6] = skip[5] ? carry[6] : carry_skip[5];
assign carry_skip[7] = skip[6] ? carry[7] : carry_skip[6];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (integer j = 0; j < 4; j = j + 1) begin
            sum_stage[j] <= 8'b0;
            carry_stage[j] <= 1'b0;
        end
        en_pipe <= 4'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1: process segments 0-1
        sum_stage[0] <= {sum[1], sum[0]};
        carry_stage[0] <= carry_skip[1];
        en_pipe[0] <= i_en;
        
        // Pipeline stage 2: process segments 2-3
        sum_stage[1] <= {sum[3], sum[2]};
        carry_stage[1] <= carry_skip[3];
        en_pipe[1] <= en_pipe[0];
        
        // Pipeline stage 3: process segments 4-5
        sum_stage[2] <= {sum[5], sum[4]};
        carry_stage[2] <= carry_skip[5];
        en_pipe[2] <= en_pipe[1];
        
        // Pipeline stage 4: process segments 6-7 and final result
        sum_stage[3] <= {sum[7], sum[6]};
        carry_stage[3] <= carry_skip[7];
        en_pipe[3] <= en_pipe[2];
        
        // Final output assembly
        result <= {carry_stage[3], 
                  sum_stage[3][15:8], sum_stage[2][15:8], 
                  sum_stage[1][15:8], sum_stage[0][15:8],
                  sum_stage[3][7:0], sum_stage[2][7:0],
                  sum_stage[1][7:0], sum_stage[0][7:0]};
        o_en <= en_pipe[3];
    end
end

endmodule