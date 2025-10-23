module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage 1: 32 bits
reg [31:0] a_stg1, b_stg1;
reg [32:0] sum_stg1;  // Includes carry out
reg en_stg1;

// Pipeline stage 2: 32 bits
reg [31:0] a_stg2, b_stg2;
reg [32:0] sum_stg2;  // Includes carry out
reg en_stg2;

// Pipeline stage 1 calculation
wire [32:0] sum1 = {1'b0, a_stg1} + {1'b0, b_stg1};

// Pipeline stage 2 calculation (includes carry from stage 1)
wire [32:0] sum2 = {1'b0, a_stg2} + {1'b0, b_stg2} + sum_stg1[32];

// Pipeline stage 1 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg1 <= 0;
        b_stg1 <= 0;
        sum_stg1 <= 0;
        en_stg1 <= 0;
    end else begin
        a_stg1 <= adda[31:0];
        b_stg1 <= addb[31:0];
        sum_stg1 <= sum1;
        en_stg1 <= i_en;
    end
end

// Pipeline stage 2 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg2 <= 0;
        b_stg2 <= 0;
        sum_stg2 <= 0;
        en_stg2 <= 0;
    end else begin
        a_stg2 <= adda[63:32];
        b_stg2 <= addb[63:32];
        sum_stg2 <= sum2;
        en_stg2 <= en_stg1;
    end
end

// Final result composition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= {sum_stg2[32], sum_stg2[31:0], sum_stg1[31:0]};
        o_en <= en_stg2;
    end
end

endmodule