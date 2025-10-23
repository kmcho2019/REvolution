module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of pipeline stages
parameter STAGES = 4;

// Define the width of each stage
parameter WIDTH = 16;

// Define the number of bits for each stage
parameter NUM_BITS = 64 / STAGES;

// Declare the internal signals
reg [63:0] stage_a [0:STAGES-1];
reg [63:0] stage_b [0:STAGES-1];
reg [STAGES-1:0] stage_en;
reg [64:0] sum [0:STAGES-1];
reg [63:0] carry [0:STAGES-1];

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_a[0] <= 64'd0;
        stage_b[0] <= 64'd0;
        stage_en[0] <= 1'b0;
    end else if (i_en) begin
        stage_a[0] <= adda;
        stage_b[0] <= addb;
        stage_en[0] <= 1'b1;
    end
end

// Pipeline stages
genvar i;
generate
    for (i = 1; i < STAGES; i++) begin : gen_stage
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                stage_a[i] <= 64'd0;
                stage_b[i] <= 64'd0;
                stage_en[i] <= 1'b0;
            end else begin
                stage_a[i] <= stage_a[i-1];
                stage_b[i] <= stage_b[i-1];
                stage_en[i] <= stage_en[i-1];
            end
        end
    end
endgenerate

// Calculate sum and carry for each stage
genvar j;
generate
    for (j = 0; j < STAGES; j++) begin : gen_sum
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                sum[j] <= 65'd0;
                carry[j] <= 64'd0;
            end else if (stage_en[j]) begin
                if (j == 0) begin
                    sum[j] <= {1'b0, stage_a[j]} + {1'b0, stage_b[j]};
                end else begin
                    sum[j] <= {1'b0, stage_a[j]} + {1'b0, stage_b[j]} + {64'd0, carry[j-1]};
                end
                carry[j] <= sum[j][64];
            end
        end
    end
endgenerate

// Output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (stage_en[STAGES-1]) begin
        result <= sum[STAGES-1];
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule