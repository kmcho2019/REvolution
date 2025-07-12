module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline enable registers (4 stages)
    reg [3:0] en_pipe;

    // Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires
    wire [15:0] partial_products [7:0];

    // Stage 1 sums (4 registers)
    reg [15:0] sum_s1_0;
    reg [15:0] sum_s1_1;
    reg [15:0] sum_s1_2;
    reg [15:0] sum_s1_3;

    // Stage 2 sums (2 registers)
    reg [15:0] sum_s2_0;
    reg [15:0] sum_s2_1;

    // Stage 3 sum (final product register)
    reg [15:0] mul_out_reg;

    integer i;

    // Input registers and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_pipe     <= 4'b0;
            mul_a_reg   <= 8'b0;
            mul_b_reg   <= 8'b0;
        end else begin
            en_pipe <= {en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally
    genvar idx;
    generate
        for (idx=0; idx<8; idx=idx+1) begin : gen_pp
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'b0;
        end
    endgenerate

    // Stage 1: Add pairs of partial products and register results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_s1_0 <= 16'b0;
            sum_s1_1 <= 16'b0;
            sum_s1_2 <= 16'b0;
            sum_s1_3 <= 16'b0;
        end else if (en_pipe[0]) begin
            sum_s1_0 <= partial_products[0] + partial_products[1];
            sum_s1_1 <= partial_products[2] + partial_products[3];
            sum_s1_2 <= partial_products[4] + partial_products[5];
            sum_s1_3 <= partial_products[6] + partial_products[7];
        end else begin
            sum_s1_0 <= 16'b0;
            sum_s1_1 <= 16'b0;
            sum_s1_2 <= 16'b0;
            sum_s1_3 <= 16'b0;
        end
    end

    // Stage 2: Add stage 1 sums pairwise and register results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_s2_0 <= 16'b0;
            sum_s2_1 <= 16'b0;
        end else if (en_pipe[1]) begin
            sum_s2_0 <= sum_s1_0 + sum_s1_1;
            sum_s2_1 <= sum_s1_2 + sum_s1_3;
        end else begin
            sum_s2_0 <= 16'b0;
            sum_s2_1 <= 16'b0;
        end
    end

    // Stage 3: Final addition and output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_out  <= 1'b0;
            mul_out     <= 16'b0;
        end else begin
            if (en_pipe[2]) begin
                mul_out_reg <= sum_s2_0 + sum_s2_1;
            end else begin
                mul_out_reg <= 16'b0;
            end
            mul_en_out <= en_pipe[3];
            mul_out <= en_pipe[3] ? mul_out_reg : 16'b0;
        end
    end

endmodule