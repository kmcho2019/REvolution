module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control
    reg [2:0] en_pipeline;

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] sum01_reg, sum23_reg;
    reg [15:0] sum45_reg, sum67_reg;
    reg [15:0] sum_low_reg, sum_high_reg;
    reg [15:0] result_reg;

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

    // Partial products (combinational)
    wire [15:0] pp0 = {8'b0, a_reg} & {16{b_reg[0]}};
    wire [15:0] pp1 = ({7'b0, a_reg, 1'b0}) & {16{b_reg[1]}};
    wire [15:0] pp2 = ({6'b0, a_reg, 2'b0}) & {16{b_reg[2]}};
    wire [15:0] pp3 = ({5'b0, a_reg, 3'b0}) & {16{b_reg[3]}};
    wire [15:0] pp4 = ({4'b0, a_reg, 4'b0}) & {16{b_reg[4]}};
    wire [15:0] pp5 = ({3'b0, a_reg, 5'b0}) & {16{b_reg[5]}};
    wire [15:0] pp6 = ({2'b0, a_reg, 6'b0}) & {16{b_reg[6]}};
    wire [15:0] pp7 = ({1'b0, a_reg, 7'b0}) & {16{b_reg[7]}};

    // Stage 2: First level additions
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01_reg <= 16'b0;
            sum23_reg <= 16'b0;
            sum45_reg <= 16'b0;
            sum67_reg <= 16'b0;
        end else if (en_pipeline[0]) begin
            sum01_reg <= sum01;
            sum23_reg <= sum23;
            sum45_reg <= sum45;
            sum67_reg <= sum67;
        end
    end

    // Stage 3: Second level additions
    wire [15:0] sum_low = sum01_reg + sum23_reg;
    wire [15:0] sum_high = sum45_reg + sum67_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_reg <= 16'b0;
            sum_high_reg <= 16'b0;
        end else if (en_pipeline[1]) begin
            sum_low_reg <= sum_low;
            sum_high_reg <= sum_high;
        end
    end

    // Final addition and result
    wire [15:0] final_sum = sum_low_reg + sum_high_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else if (en_pipeline[2]) begin
            result_reg <= final_sum;
        end
    end

    // Enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipeline <= 3'b0;
        end else begin
            en_pipeline <= {en_pipeline[1:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[2];
    assign mul_out = en_pipeline[2] ? result_reg : 16'b0;

endmodule