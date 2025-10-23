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
reg [31:0] a_low, b_low, a_high, b_high;
reg [32:0] sum_low;
reg [1:0] en_pipe;

// Stage 1: Register lower 32 bits and enable signal
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_low <= 32'b0;
        b_low <= 32'b0;
        a_high <= 32'b0;
        b_high <= 32'b0;
        en_pipe <= 2'b0;
    end else begin
        if (i_en) begin
            a_low <= adda[31:0];
            b_low <= addb[31:0];
            a_high <= adda[63:32];
            b_high <= addb[63:32];
        end
        en_pipe <= {en_pipe[0], i_en};
    end
end

// Stage 2: Add lower 32 bits
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low <= 33'b0;
    end else if (en_pipe[0]) begin
        sum_low <= {1'b0, a_low} + {1'b0, b_low};
    end
end

// Stage 3: Add upper 32 bits with carry and assemble final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else if (en_pipe[1]) begin
        result <= {1'b0, a_high} + {1'b0, b_high} + sum_low[32];
        result[31:0] <= sum_low[31:0];
        o_en <= 1'b1;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule