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
reg [15:0] a0, a1, a2, a3;
reg [15:0] b0, b1, b2, b3;
reg [16:0] sum0, sum1, sum2;
reg [16:0] final_sum;
reg en0, en1, en2, en3;

// Internal carry signals
wire carry0, carry1, carry2;

// Pipeline stage 0: Process bits [15:0]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a0 <= 16'b0;
        b0 <= 16'b0;
        en0 <= 1'b0;
    end else begin
        a0 <= adda[15:0];
        b0 <= addb[15:0];
        en0 <= i_en;
    end
end

assign {carry0, sum0[15:0]} = a0 + b0;
assign sum0[16] = carry0;

// Pipeline stage 1: Process bits [31:16]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a1 <= 16'b0;
        b1 <= 16'b0;
        sum1 <= 17'b0;
        en1 <= 1'b0;
    end else begin
        a1 <= adda[31:16];
        b1 <= addb[31:16];
        sum1 <= sum0;
        en1 <= en0;
    end
end

assign {carry1, sum1[15:0]} = a1 + b1 + sum0[16];
assign sum1[16] = carry1;

// Pipeline stage 2: Process bits [47:32]
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a2 <= 16'b0;
        b2 <= 16'b0;
        sum2 <= 17'b0;
        en2 <= 1'b0;
    end else begin
        a2 <= adda[47:32];
        b2 <= addb[47:32];
        sum2 <= sum1;
        en2 <= en1;
    end
end

assign {carry2, sum2[15:0]} = a2 + b2 + sum1[16];
assign sum2[16] = carry2;

// Pipeline stage 3: Process bits [63:48] and final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a3 <= 16'b0;
        b3 <= 16'b0;
        final_sum <= 17'b0;
        en3 <= 1'b0;
        o_en <= 1'b0;
        result <= 65'b0;
    end else begin
        a3 <= adda[63:48];
        b3 <= addb[63:48];
        final_sum <= sum2;
        en3 <= en2;
        o_en <= en3;
        
        // Concatenate all partial sums with final carry
        result <= {a3 + b3 + sum2[16], final_sum[15:0], sum1[15:0], sum0[15:0]};
    end
end

endmodule