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
reg [20:0] sum1;  // Stage 1 sum (bits 0-20)
reg [20:0] sum2;  // Stage 2 sum (bits 21-41)
reg carry1, carry2;
reg [2:0] en_pipe;

// Stage 1: Add bits 0-20
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 21'b0;
        carry1 <= 1'b0;
        en_pipe <= 3'b0;
    end else begin
        {carry1, sum1} <= adda[20:0] + addb[20:0];
        en_pipe <= {en_pipe[1:0], i_en};
    end
end

// Stage 2: Add bits 21-41 with carry from stage1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 21'b0;
        carry2 <= 1'b0;
    end else begin
        {carry2, sum2} <= adda[41:21] + addb[41:21] + carry1;
    end
end

// Stage 3: Add bits 42-63 with carry from stage2 and combine results
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result[63:0] <= {adda[63:42] + addb[63:42] + carry2, sum2, sum1};
        result[64] <= adda[63:42] + addb[63:42] + carry2 > {22{1'b1}};
        o_en <= en_pipe[2];
    end
end

endmodule