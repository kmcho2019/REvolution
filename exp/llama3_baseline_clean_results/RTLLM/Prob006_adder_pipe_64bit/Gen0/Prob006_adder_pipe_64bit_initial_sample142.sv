module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_pipe;
reg [63:0] addb_pipe;
reg i_en_pipe;
reg [64:0] sum_pipe;
reg o_en_pipe;

// Input Stage
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe <= 64'd0;
        addb_pipe <= 64'd0;
        i_en_pipe <= 1'b0;
    end else if (i_en) begin
        adda_pipe <= adda;
        addb_pipe <= addb;
        i_en_pipe <= i_en;
    end
end

// Ripple Carry Adder and Pipeline Stages
reg [63:0] sum;
reg carry;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 64'd0;
        carry <= 1'b0;
        sum_pipe <= 65'd0;
        o_en_pipe <= 1'b0;
    end else if (i_en_pipe) begin
        carry <= 1'b0;
        for (int i = 0; i < 64; i++) begin
            if (i == 0) begin
                sum[i] <= adda_pipe[i] ^ addb_pipe[i] ^ carry;
                carry <= (adda_pipe[i] & addb_pipe[i]) | (adda_pipe[i] & carry) | (addb_pipe[i] & carry);
            end else begin
                sum[i] <= adda_pipe[i] ^ addb_pipe[i] ^ carry;
                carry <= (adda_pipe[i] & addb_pipe[i]) | (adda_pipe[i] & carry) | (addb_pipe[i] & carry);
            end
        end
        sum_pipe <= {carry, sum};
        o_en_pipe <= 1'b1;
    end else begin
        sum_pipe <= sum_pipe;
        o_en_pipe <= o_en_pipe;
    end
end

// Output Stage
assign result = sum_pipe;
assign o_en = o_en_pipe;

endmodule