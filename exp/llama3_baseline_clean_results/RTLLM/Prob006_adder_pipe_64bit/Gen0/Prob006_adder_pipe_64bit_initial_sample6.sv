module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] pipe_adda;
reg [63:0] pipe_addb;
reg pipe_i_en;
reg [63:0] pipe_sum;
reg [63:0] pipe_carry;
reg pipe_o_en;

// Pipeline stage 1: Hold input operands and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipe_adda <= 64'd0;
        pipe_addb <= 64'd0;
        pipe_i_en <= 1'b0;
    end else if (i_en) begin
        pipe_adda <= adda;
        pipe_addb <= addb;
        pipe_i_en <= 1'b1;
    end
end

// Pipeline stage 2: Calculate carry signals
reg [63:0] carry;
always @(*) begin
    carry[0] = pipe_adda[0] & pipe_addb[0];
    for (int i = 1; i < 64; i++) begin
        carry[i] = (pipe_adda[i] & pipe_addb[i]) | (pipe_adda[i] & carry[i-1]) | (pipe_addb[i] & carry[i-1]);
    end
end

// Pipeline stage 3: Calculate sum values
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipe_sum <= 64'd0;
        pipe_carry <= 64'd0;
    end else if (pipe_i_en) begin
        for (int i = 0; i < 64; i++) begin
            pipe_sum[i] <= pipe_adda[i] ^ pipe_addb[i] ^ carry[i];
        end
        pipe_carry <= carry;
    end
end

// Pipeline stage 4: Calculate output and enable signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipe_o_en <= 1'b0;
        result <= 65'd0;
    end else if (pipe_i_en) begin
        pipe_o_en <= 1'b1;
        result <= {1'b0, pipe_sum} + {64'd1, pipe_carry};
    end else begin
        pipe_o_en <= 1'b0;
    end
end

assign o_en = pipe_o_en;

endmodule