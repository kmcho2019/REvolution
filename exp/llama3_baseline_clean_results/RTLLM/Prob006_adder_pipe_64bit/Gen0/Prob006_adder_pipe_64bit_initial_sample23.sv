module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// internal signals
reg [63:0] adda_pipe [3:0];
reg [63:0] addb_pipe [3:0];
reg [63:0] sum_pipe [3:0];
reg carry_pipe [3:0];
reg i_en_pipe [3:0];

// input pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe[0] <= 64'd0;
        addb_pipe[0] <= 64'd0;
        i_en_pipe[0] <= 1'b0;
    end else if (i_en) begin
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        i_en_pipe[0] <= 1'b1;
    end else begin
        adda_pipe[0] <= adda_pipe[0];
        addb_pipe[0] <= addb_pipe[0];
        i_en_pipe[0] <= i_en_pipe[0];
    end
end

// internal pipeline stages
genvar i;
generate
    for (i = 1; i < 4; i++) begin : pipeline_stage
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                i_en_pipe[i] <= 1'b0;
                sum_pipe[i-1] <= 64'd0;
                carry_pipe[i-1] <= 1'b0;
            end else begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
                
                if (i == 1) begin
                    sum_pipe[i-1] <= adda_pipe[i-1] + addb_pipe[i-1];
                    carry_pipe[i-1] <= (adda_pipe[i-1][63] + addb_pipe[i-1][63] + carry_pipe[i-1]) > 1'b1;
                end else begin
                    sum_pipe[i-1] <= sum_pipe[i-2] + (adda_pipe[i-1] + addb_pipe[i-1]);
                    carry_pipe[i-1] <= (sum_pipe[i-2][63] + adda_pipe[i-1][63] + addb_pipe[i-1][63] + carry_pipe[i-2]) > 1'b1;
                end
            end
        end
    end
endgenerate

// output pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en_pipe[3]) begin
        result <= {1'b0, sum_pipe[3]} + {64'd0, carry_pipe[3]};
        o_en <= 1'b1;
    end else begin
        result <= result;
        o_en <= 1'b0;
    end
end

endmodule