module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the number of bits in the adder
parameter BITS = 64;

// Define the number of pipeline stages
parameter PIPE_STAGES = 2;

// Define the width of the output result
parameter RESULT_WIDTH = BITS + 1;

// Internal signals
reg [BITS-1:0] adda_pipe [PIPE_STAGES-1:0];
reg [BITS-1:0] addb_pipe [PIPE_STAGES-1:0];
reg [RESULT_WIDTH-1:0] result_pipe [PIPE_STAGES-1:0];
reg i_en_pipe [PIPE_STAGES-1:0];

// Register the input enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_pipe[0] <= 0;
    end else if (i_en) begin
        i_en_pipe[0] <= 1;
    end else begin
        i_en_pipe[0] <= 0;
    end
end

// Pipeline the input enable signal
genvar i;
for (i = 1; i < PIPE_STAGES; i++) begin
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            i_en_pipe[i] <= 0;
        end else begin
            i_en_pipe[i] <= i_en_pipe[i-1];
        end
    end
end

// Register the input operands
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe[0] <= 0;
        addb_pipe[0] <= 0;
    end else if (i_en) begin
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
    end else begin
        adda_pipe[0] <= adda_pipe[0];
        addb_pipe[0] <= addb_pipe[0];
    end
end

// Pipeline the input operands
for (i = 1; i < PIPE_STAGES; i++) begin
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            adda_pipe[i] <= 0;
            addb_pipe[i] <= 0;
        end else begin
            adda_pipe[i] <= adda_pipe[i-1];
            addb_pipe[i] <= addb_pipe[i-1];
        end
    end
end

// Calculate the sum and carry for each bit position
reg [BITS-1:0] sum;
reg [BITS-1:0] carry;
always @(*) begin
    sum = adda_pipe[PIPE_STAGES-1] + addb_pipe[PIPE_STAGES-1];
    carry = (adda_pipe[PIPE_STAGES-1] & addb_pipe[PIPE_STAGES-1]) | (adda_pipe[PIPE_STAGES-1] & {BITS{1'b1}} + addb_pipe[PIPE_STAGES-1]);
end

// Register the result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_pipe[0] <= 0;
    end else if (i_en_pipe[0]) begin
        result_pipe[0] <= {1'b0, adda_pipe[0]} + {1'b0, addb_pipe[0]};
    end else begin
        result_pipe[0] <= result_pipe[0];
    end
end

// Pipeline the result
for (i = 1; i < PIPE_STAGES; i++) begin
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            result_pipe[i] <= 0;
        end else if (i_en_pipe[i]) begin
            result_pipe[i] <= result_pipe[i-1] + {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]};
        end else begin
            result_pipe[i] <= result_pipe[i];
        end
    end
end

// Assign the output result
assign result = result_pipe[PIPE_STAGES-1];

// Update the output enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en <= 0;
    end else if (i_en_pipe[PIPE_STAGES-1]) begin
        o_en <= 1;
    end else begin
        o_en <= 0;
    end
end

endmodule