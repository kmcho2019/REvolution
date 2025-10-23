module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [63:0] stage1_a, stage1_b;
reg [63:0] stage2_a, stage2_b;
reg [2:0] en_pipe;

// Carry chain registers
reg [63:0] carry_chain;

// Stage 1: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'b0;
        stage1_b <= 64'b0;
        en_pipe <= 3'b0;
    end else begin
        stage1_a <= adda;
        stage1_b <= addb;
        en_pipe <= {en_pipe[1:0], i_en};
    end
end

// Stage 2: Ripple-carry computation
wire [63:0] sum_stage2;
wire [63:0] carry_stage2;

assign sum_stage2[0] = stage1_a[0] ^ stage1_b[0];
assign carry_stage2[0] = stage1_a[0] & stage1_b[0];

genvar i;
generate
    for (i = 1; i < 64; i = i + 1) begin: RCA
        assign sum_stage2[i] = stage1_a[i] ^ stage1_b[i] ^ carry_stage2[i-1];
        assign carry_stage2[i] = (stage1_a[i] & stage1_b[i]) | 
                                ((stage1_a[i] | stage1_b[i]) & carry_stage2[i-1]);
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_a <= 64'b0;
        stage2_b <= 64'b0;
        carry_chain <= 64'b0;
    end else begin
        stage2_a <= stage1_a;
        stage2_b <= stage1_b;
        carry_chain <= carry_stage2;
    end
end

// Stage 3: Final output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {1'b0, sum_stage2} + {64'b0, carry_chain[63]};
        o_en <= en_pipe[2];
    end
end

endmodule