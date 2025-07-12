module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output  reg         mul_en_out,
    output  reg [15:0]  mul_out
);

    // Pipeline depth = 3

    // Enable shift register for tracking input validity through pipeline
    reg [2:0] mul_en_pipe;

    // Input operand registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 1: register inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 3'b0;
            mul_a_reg   <= 8'b0;
            mul_b_reg   <= 8'b0;
        end else begin
            mul_en_pipe[0] <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
            mul_en_pipe[2:1] <= mul_en_pipe[1:0];
        end
    end

    // Partial products generation (combinational)
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 2: sum pairs of partial products and register sums
    reg [15:0] sum_pairs[3:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<4; j=j+1) sum_pairs[j] <= 16'b0;
        end else if (mul_en_pipe[0]) begin
            sum_pairs[0] <= partial_products[0] + partial_products[1];
            sum_pairs[1] <= partial_products[2] + partial_products[3];
            sum_pairs[2] <= partial_products[4] + partial_products[5];
            sum_pairs[3] <= partial_products[6] + partial_products[7];
        end else begin
            for (j=0; j<4; j=j+1) sum_pairs[j] <= 16'b0;
        end
    end

    // Stage 3: final product calculation and output registers
    wire [15:0] sum_stage = (sum_pairs[0] + sum_pairs[1]) + (sum_pairs[2] + sum_pairs[3]);
    reg [15:0] mul_out_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            if (mul_en_pipe[1]) begin
                mul_out_reg <= sum_stage;
            end else begin
                mul_out_reg <= 16'b0;
            end

            mul_en_out <= mul_en_pipe[2];
            mul_out <= mul_en_pipe[2] ? mul_out_reg : 16'b0;
        end
    end

endmodule