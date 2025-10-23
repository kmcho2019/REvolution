module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline enable signals
    reg [3:0] en_pipeline;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) en_pipeline <= 4'b0;
        else en_pipeline <= {en_pipeline[2:0], mul_en_in};
    end
    assign mul_en_out = en_pipeline[3];

    // Stage 1: Input registers
    reg [7:0] a_reg, b_reg;
    always @(posedge clk) begin
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 2: Partial products (combinational)
    wire [15:0] pp0 = b_reg[0] ? {8'b0, a_reg} : 16'b0;
    wire [15:0] pp1 = b_reg[1] ? {7'b0, a_reg, 1'b0} : 16'b0;
    wire [15:0] pp2 = b_reg[2] ? {6'b0, a_reg, 2'b0} : 16'b0;
    wire [15:0] pp3 = b_reg[3] ? {5'b0, a_reg, 3'b0} : 16'b0;
    wire [15:0] pp4 = b_reg[4] ? {4'b0, a_reg, 4'b0} : 16'b0;
    wire [15:0] pp5 = b_reg[5] ? {3'b0, a_reg, 5'b0} : 16'b0;
    wire [15:0] pp6 = b_reg[6] ? {2'b0, a_reg, 6'b0} : 16'b0;
    wire [15:0] pp7 = b_reg[7] ? {1'b0, a_reg, 7'b0} : 16'b0;

    // Stage 2: First level sums (registered)
    reg [15:0] sum01, sum23, sum45, sum67;
    always @(posedge clk) begin
        if (en_pipeline[0]) begin
            sum01 <= pp0 + pp1;
            sum23 <= pp2 + pp3;
            sum45 <= pp4 + pp5;
            sum67 <= pp6 + pp7;
        end
    end

    // Stage 3: Second level sums (registered)
    reg [15:0] sum_low, sum_high;
    always @(posedge clk) begin
        if (en_pipeline[1]) begin
            sum_low <= sum01 + sum23;
            sum_high <= sum45 + sum67;
        end
    end

    // Stage 4: Final sum (registered)
    reg [15:0] result;
    always @(posedge clk) begin
        if (en_pipeline[2]) begin
            result <= sum_low + sum_high;
        end
    end

    // Output assignment
    assign mul_out = en_pipeline[3] ? result : 16'b0;

endmodule