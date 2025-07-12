module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage 1: 22 bits
reg [21:0] a_stg1, b_stg1;
reg [21:0] sum_stg1;
reg carry_stg1;
reg en_stg1;

// Pipeline stage 2: 22 bits
reg [21:0] a_stg2, b_stg2;
reg [21:0] sum_stg2;
reg carry_stg2;
reg en_stg2;

// Pipeline stage 3: 20 bits
reg [19:0] a_stg3, b_stg3;
reg [19:0] sum_stg3;
reg carry_stg3;
reg en_stg3;

// Intermediate results
wire [21:0] sum1 = a_stg1 + b_stg1;
wire [21:0] sum2 = a_stg2 + b_stg2 + carry_stg1;
wire [19:0] sum3 = a_stg3 + b_stg3 + carry_stg2;

// Pipeline stage 1 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg1 <= 0;
        b_stg1 <= 0;
        sum_stg1 <= 0;
        carry_stg1 <= 0;
        en_stg1 <= 0;
    end else begin
        a_stg1 <= adda[21:0];
        b_stg1 <= addb[21:0];
        sum_stg1 <= sum1[21:0];
        carry_stg1 <= sum1[22];
        en_stg1 <= i_en;
    end
end

// Pipeline stage 2 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg2 <= 0;
        b_stg2 <= 0;
        sum_stg2 <= 0;
        carry_stg2 <= 0;
        en_stg2 <= 0;
    end else begin
        a_stg2 <= adda[43:22];
        b_stg2 <= addb[43:22];
        sum_stg2 <= sum2[21:0];
        carry_stg2 <= sum2[22];
        en_stg2 <= en_stg1;
    end
end

// Pipeline stage 3 registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_stg3 <= 0;
        b_stg3 <= 0;
        sum_stg3 <= 0;
        carry_stg3 <= 0;
        en_stg3 <= 0;
    end else begin
        a_stg3 <= adda[63:44];
        b_stg3 <= addb[63:44];
        sum_stg3 <= sum3[19:0];
        carry_stg3 <= sum3[20];
        en_stg3 <= en_stg2;
    end
end

// Final result composition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 0;
        o_en <= 0;
    end else begin
        result <= {carry_stg3, sum_stg3, sum_stg2, sum_stg1};
        o_en <= en_stg3;
    end
end

endmodule