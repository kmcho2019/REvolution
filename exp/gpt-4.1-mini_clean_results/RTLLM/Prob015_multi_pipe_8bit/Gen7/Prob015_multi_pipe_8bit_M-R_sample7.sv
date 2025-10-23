module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline enable signal shift register (4-stage)
    reg [3:0] en_pipe;

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: Partial products registers
    reg [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

    // Stage 2: Pairwise sums registers
    reg [15:0] sum01, sum23, sum45, sum67;

    // Stage 3: Intermediate sums registers
    reg [15:0] sum0123, sum4567;

    // Stage 4: Final product register
    reg [15:0] mul_out_reg;

    // Stage 1: Sample inputs and enable, generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;

            pp0 <= 16'b0; pp1 <= 16'b0; pp2 <= 16'b0; pp3 <= 16'b0;
            pp4 <= 16'b0; pp5 <= 16'b0; pp6 <= 16'b0; pp7 <= 16'b0;
        end else begin
            en_pipe <= {en_pipe[2:0], mul_en_in};

            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Generate partial products conditionally based on mul_b_reg bits
            pp0 <= mul_b_reg[0] ? {8'b0, mul_a_reg}           : 16'b0;
            pp1 <= mul_b_reg[1] ? ({7'b0, mul_a_reg} << 1)    : 16'b0;
            pp2 <= mul_b_reg[2] ? ({6'b0, mul_a_reg} << 2)    : 16'b0;
            pp3 <= mul_b_reg[3] ? ({5'b0, mul_a_reg} << 3)    : 16'b0;
            pp4 <= mul_b_reg[4] ? ({4'b0, mul_a_reg} << 4)    : 16'b0;
            pp5 <= mul_b_reg[5] ? ({3'b0, mul_a_reg} << 5)    : 16'b0;
            pp6 <= mul_b_reg[6] ? ({2'b0, mul_a_reg} << 6)    : 16'b0;
            pp7 <= mul_b_reg[7] ? ({1'b0, mul_a_reg} << 7)    : 16'b0;
        end
    end

    // Stage 2: Sum partial products pairwise
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum01 <= 16'b0; sum23 <= 16'b0; sum45 <= 16'b0; sum67 <= 16'b0;
        end else begin
            if (en_pipe[0]) begin
                sum01 <= pp0 + pp1;
                sum23 <= pp2 + pp3;
                sum45 <= pp4 + pp5;
                sum67 <= pp6 + pp7;
            end else begin
                sum01 <= 16'b0; sum23 <= 16'b0; sum45 <= 16'b0; sum67 <= 16'b0;
            end
        end
    end

    // Stage 3: Sum intermediate pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0123 <= 16'b0;
            sum4567 <= 16'b0;
        end else begin
            if (en_pipe[1]) begin
                sum0123 <= sum01 + sum23;
                sum4567 <= sum45 + sum67;
            end else begin
                sum0123 <= 16'b0;
                sum4567 <= 16'b0;
            end
        end
    end

    // Stage 4: Final sum and output registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            if (en_pipe[2]) begin
                mul_out_reg <= sum0123 + sum4567;
            end else begin
                mul_out_reg <= 16'b0;
            end

            mul_en_out <= en_pipe[3];
            mul_out <= en_pipe[3] ? mul_out_reg : 16'b0;
        end
    end

endmodule