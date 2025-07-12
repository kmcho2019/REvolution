module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_pipe1;
reg [63:0] addb_pipe1;
reg [63:0] adda_pipe2;
reg [63:0] addb_pipe2;
reg i_en_pipe1;
reg i_en_pipe2;
reg [64:0] sum;
reg [64:0] result_pipe;

assign result = result_pipe;
assign o_en = i_en_pipe2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe1 <= 64'd0;
        addb_pipe1 <= 64'd0;
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
        i_en_pipe1 <= 1'b0;
        i_en_pipe2 <= 1'b0;
        result_pipe <= 65'd0;
    end else begin
        adda_pipe1 <= adda;
        addb_pipe1 <= addb;
        i_en_pipe1 <= i_en;
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        i_en_pipe2 <= i_en_pipe1;
        
        if (i_en_pipe2) begin
            result_pipe <= sum;
        end else begin
            result_pipe <= 65'd0;
        end
    end
end

// 64-bit ripple carry adder
wire [63:0] sum_a;
wire [63:0] sum_b;
wire [63:0] carry;

assign sum_a = adda_pipe2;
assign sum_b = addb_pipe2;

assign carry[0] = 1'b0;
assign result_pipe[0] = sum_a[0] ^ sum_b[0] ^ carry[0];
assign result_pipe[64] = carry[63];

integer i;
always @(*) begin
    for (i = 1; i < 64; i = i + 1) begin
        assign carry[i] = (sum_a[i] & sum_b[i]) | (sum_a[i] & carry[i-1]) | (sum_b[i] & carry[i-1]);
        assign result_pipe[i] = sum_a[i] ^ sum_b[i] ^ carry[i-1];
    end
end

endmodule