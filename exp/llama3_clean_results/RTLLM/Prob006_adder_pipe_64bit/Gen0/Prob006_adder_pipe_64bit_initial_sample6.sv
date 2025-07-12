module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] pipe_a;
reg [63:0] pipe_b;
reg [63:0] sum;
reg [63:0] carry;
reg o_en_pipe;
reg i_en_pipe;

// Input register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        pipe_a <= 64'd0;
        pipe_b <= 64'd0;
        i_en_pipe <= 1'b0;
    end else if (i_en) begin
        pipe_a <= adda;
        pipe_b <= addb;
        i_en_pipe <= i_en;
    end else begin
        pipe_a <= pipe_a;
        pipe_b <= pipe_b;
        i_en_pipe <= i_en_pipe;
    end
end

// Ripple carry adder
always @(*) begin
    result[0] = pipe_a[0] ^ pipe_b[0] ^ carry[0];
    result[64] = carry[63];
    for (int i = 1; i < 64; i++) begin
        result[i] = pipe_a[i] ^ pipe_b[i] ^ carry[i-1];
    end
    carry[0] = pipe_a[0] & pipe_b[0];
    for (int i = 1; i < 64; i++) begin
        carry[i] = (pipe_a[i] & pipe_b[i]) | (pipe_a[i] & carry[i-1]) | (pipe_b[i] & carry[i-1]);
    end
end

// Output enable register
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_pipe <= 1'b0;
    end else if (i_en_pipe) begin
        o_en_pipe <= 1'b1;
    end else if (~i_en_pipe) begin
        o_en_pipe <= 1'b0;
    end
end

assign o_en = o_en_pipe;

endmodule