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
reg [15:0] adda_0, addb_0;
reg [15:0] adda_1, addb_1;
reg [15:0] adda_2, addb_2;
reg [15:0] adda_3, addb_3;

reg [16:0] sum_0;
reg [16:0] sum_1;
reg [16:0] sum_2;

reg en_0, en_1, en_2, en_3;

wire [16:0] sum_0_next;
wire [16:0] sum_1_next;
wire [16:0] sum_2_next;
wire [16:0] sum_3_next;

// Stage 0: Input registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_0 <= 16'b0;
        addb_0 <= 16'b0;
        en_0 <= 1'b0;
    end else begin
        adda_0 <= adda[15:0];
        addb_0 <= addb[15:0];
        en_0 <= i_en;
    end
end

// Stage 0 addition
assign sum_0_next = {1'b0, adda_0} + {1'b0, addb_0};

// Stage 1: First 16-bit addition and registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_1 <= 16'b0;
        addb_1 <= 16'b0;
        sum_0 <= 17'b0;
        en_1 <= 1'b0;
    end else begin
        adda_1 <= adda[31:16];
        addb_1 <= addb[31:16];
        sum_0 <= sum_0_next;
        en_1 <= en_0;
    end
end

// Stage 1 addition (with carry from stage 0)
assign sum_1_next = {1'b0, adda_1} + {1'b0, addb_1} + sum_0[16];

// Stage 2: Second 16-bit addition and registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_2 <= 16'b0;
        addb_2 <= 16'b0;
        sum_1 <= 17'b0;
        en_2 <= 1'b0;
    end else begin
        adda_2 <= adda[47:32];
        addb_2 <= addb[47:32];
        sum_1 <= sum_1_next;
        en_2 <= en_1;
    end
end

// Stage 2 addition (with carry from stage 1)
assign sum_2_next = {1'b0, adda_2} + {1'b0, addb_2} + sum_1[16];

// Stage 3: Third 16-bit addition and registration
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_3 <= 16'b0;
        addb_3 <= 16'b0;
        sum_2 <= 17'b0;
        en_3 <= 1'b0;
    end else begin
        adda_3 <= adda[63:48];
        addb_3 <= addb[63:48];
        sum_2 <= sum_2_next;
        en_3 <= en_2;
    end
end

// Stage 3 addition (with carry from stage 2)
assign sum_3_next = {1'b0, adda_3} + {1'b0, addb_3} + sum_2[16];

// Output stage: Combine all partial sums
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        result <= {sum_3_next[15:0], sum_2[15:0], sum_1[15:0], sum_0[15:0]};
        o_en <= en_3;
    end
end

endmodule