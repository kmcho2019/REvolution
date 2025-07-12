module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline enable signals (4 stages)
reg [3:0] en_pipe;

// Stage 1: Input registers and initial sum
reg [63:0] a_reg, b_reg;
reg [15:0] sum0;
reg carry0;

// Stage 2: First 32-bit addition
reg [31:0] sum1;
reg carry1;

// Stage 3: Second 32-bit addition
reg [31:0] sum2;
reg carry2;

// Stage 4: Final combination
reg [31:0] sum3;

// Pipeline stage 1: Input registration and first 16-bit addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_reg <= 64'b0;
        b_reg <= 64'b0;
        sum0 <= 16'b0;
        carry0 <= 1'b0;
        en_pipe <= 4'b0;
    end else begin
        en_pipe <= {en_pipe[2:0], i_en};
        
        if (i_en) begin
            a_reg <= adda;
            b_reg <= addb;
            {carry0, sum0} <= adda[15:0] + addb[15:0];
        end else begin
            {carry0, sum0} <= 17'b0;
        end
    end
end

// Pipeline stage 2: First 32-bit addition (16-47 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 32'b0;
        carry1 <= 1'b0;
    end else begin
        if (en_pipe[0]) begin
            {carry1, sum1} <= {1'b0, a_reg[31:16]} + {1'b0, b_reg[31:16]} + carry0;
        end else begin
            {carry1, sum1} <= 33'b0;
        end
    end
end

// Pipeline stage 3: Second 32-bit addition (32-63 bits)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum2 <= 32'b0;
        carry2 <= 1'b0;
    end else begin
        if (en_pipe[1]) begin
            {carry2, sum2} <= {1'b0, a_reg[47:32]} + {1'b0, b_reg[47:32]} + carry1;
        end else begin
            {carry2, sum2} <= 33'b0;
        end
    end
end

// Pipeline stage 4: Final 16-bit addition and result assembly
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum3 <= 32'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        if (en_pipe[2]) begin
            sum3 <= a_reg[63:48] + b_reg[63:48] + carry2;
            result <= {sum3[15:0], sum2, sum1, sum0};
        end else begin
            result <= 65'b0;
        end
        o_en <= en_pipe[3];
    end
end

endmodule