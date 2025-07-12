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
reg [63:0] adda_pipe [0:3];
reg [63:0] addb_pipe [0:3];
reg [3:0] carry_pipe;
reg [3:0] en_pipe;

// Segment sums (with carry 0 and 1)
wire [16:0] sum0_0, sum0_1;  // Bits 15:0
wire [16:0] sum1_0, sum1_1;  // Bits 31:16
wire [16:0] sum2_0, sum2_1;  // Bits 47:32
wire [16:0] sum3_0, sum3_1;  // Bits 63:48

// Intermediate carry signals
wire carry0, carry1, carry2;

// Compute all segment sums in parallel
assign sum0_0 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]};
assign sum0_1 = {1'b0, adda[15:0]} + {1'b0, addb[15:0]} + 1'b1;

assign sum1_0 = {1'b0, adda[31:16]} + {1'b0, addb[31:16]};
assign sum1_1 = {1'b0, adda[31:16]} + {1'b0, addb[31:16]} + 1'b1;

assign sum2_0 = {1'b0, adda[47:32]} + {1'b0, addb[47:32]};
assign sum2_1 = {1'b0, adda[47:32]} + {1'b0, addb[47:32]} + 1'b1;

assign sum3_0 = {1'b0, adda[63:48]} + {1'b0, addb[63:48]};
assign sum3_1 = {1'b0, adda[63:48]} + {1'b0, addb[63:48]} + 1'b1;

// Pipeline stage 0 (bits 15:0)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe[0] <= 64'b0;
        addb_pipe[0] <= 64'b0;
        carry_pipe[0] <= 1'b0;
        en_pipe[0] <= 1'b0;
    end else begin
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        carry_pipe[0] <= sum0_0[16] ? 1'b1 : 1'b0;  // Actual carry out
        en_pipe[0] <= i_en;
    end
end

// Pipeline stage 1 (bits 31:16)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe[1] <= 64'b0;
        addb_pipe[1] <= 64'b0;
        carry_pipe[1] <= 1'b0;
        en_pipe[1] <= 1'b0;
    end else begin
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        carry_pipe[1] <= carry_pipe[0] ? sum1_1[16] : sum1_0[16];
        en_pipe[1] <= en_pipe[0];
    end
end

// Pipeline stage 2 (bits 47:32)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe[2] <= 64'b0;
        addb_pipe[2] <= 64'b0;
        carry_pipe[2] <= 1'b0;
        en_pipe[2] <= 1'b0;
    end else begin
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        carry_pipe[2] <= carry_pipe[1] ? sum2_1[16] : sum2_0[16];
        en_pipe[2] <= en_pipe[1];
    end
end

// Pipeline stage 3 (bits 63:48)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_pipe[3] <= 64'b0;
        addb_pipe[3] <= 64'b0;
        carry_pipe[3] <= 1'b0;
        en_pipe[3] <= 1'b0;
    end else begin
        adda_pipe[3] <= adda_pipe[2];
        addb_pipe[3] <= addb_pipe[2];
        carry_pipe[3] <= carry_pipe[2] ? sum3_1[16] : sum3_0[16];
        en_pipe[3] <= en_pipe[2];
    end
end

// Final output assembly
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Select appropriate sums based on carry chain
        result <= {
            carry_pipe[3],
            carry_pipe[2] ? sum3_1[15:0] : sum3_0[15:0],
            carry_pipe[1] ? sum2_1[15:0] : sum2_0[15:0],
            carry_pipe[0] ? sum1_1[15:0] : sum1_0[15:0],
            sum0_0[15:0]
        };
        o_en <= en_pipe[3];
    end
end

endmodule