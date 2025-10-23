module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control signals
    reg [2:0] en_pipeline;
    assign mul_en_out = en_pipeline[2];

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] sum01_reg, sum23_reg;
    reg [15:0] sum45_reg, sum67_reg;
    reg [15:0] result_reg;

    // Partial products
    wire [15:0] pp0 = b_reg[0] ? {8'b0, a_reg} : 16'b0;
    wire [15:0] pp1 = b_reg[1] ? {7'b0, a_reg, 1'b0} : 16'b0;
    wire [15:0] pp2 = b_reg[2] ? {6'b0, a_reg, 2'b0} : 16'b0;
    wire [15:0] pp3 = b_reg[3] ? {5'b0, a_reg, 3'b0} : 16'b0;
    wire [15:0] pp4 = b_reg[4] ? {4'b0, a_reg, 4'b0} : 16'b0;
    wire [15:0] pp5 = b_reg[5] ? {3'b0, a_reg, 5'b0} : 16'b0;
    wire [15:0] pp6 = b_reg[6] ? {2'b0, a_reg, 6'b0} : 16'b0;
    wire [15:0] pp7 = b_reg[7] ? {1'b0, a_reg, 7'b0} : 16'b0;

    // Stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
        end else if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end
    end

    // Stage 2: First level additions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= 16'b0;
            sum23_reg <= 16'b0;
            sum45_reg <= 16'b0;
            sum67_reg <= 16'b0;
        end else if (en_pipeline[0]) begin
            sum01_reg <= pp0 + pp1;
            sum23_reg <= pp2 + pp3;
            sum45_reg <= pp4 + pp5;
            sum67_reg <= pp6 + pp7;
        end
    end

    // Stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else if (en_pipeline[1]) begin
            result_reg <= (sum01_reg + sum23_reg) + (sum45_reg + sum67_reg);
        end
    end

    // Enable signal pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 3'b0;
        end else begin
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignment
    assign mul_out = mul_en_out ? result_reg : 16'b0;

endmodule