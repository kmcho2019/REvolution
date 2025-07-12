module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline registers for enable signal (4 stages)
    reg [3:0] mul_en_pipe;

    // Stage 1: Input registers
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Stage 2: Partial products
    wire [15:0] partial_products [7:0];

    // Stage 2 registers (register partial products)
    reg [15:0] pp_reg [7:0];

    // Stage 3: Partial sums of pairs (4 sums)
    reg [15:0] sum_pairs [3:0];

    // Stage 4: Partial sums of pairs of sums (2 sums)
    reg [15:0] sum_quads [1:0];

    // Stage 5: Final sum (1 sum)
    reg [15:0] final_sum;

    integer i;

    // Input sampling and enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products combinationally
    genvar idx;
    generate
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_pp
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Register partial products at stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= 16'd0;
        end else if (mul_en_pipe[0]) begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= partial_products[i];
        end else begin
            for (i=0; i<8; i=i+1)
                pp_reg[i] <= 16'd0;
        end
    end

    // Stage 3: Sum pairs of partial products (4 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<4; i=i+1)
                sum_pairs[i] <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_pairs[0] <= pp_reg[0] + pp_reg[1];
            sum_pairs[1] <= pp_reg[2] + pp_reg[3];
            sum_pairs[2] <= pp_reg[4] + pp_reg[5];
            sum_pairs[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for (i=0; i<4; i=i+1)
                sum_pairs[i] <= 16'd0;
        end
    end

    // Stage 4: Sum pairs of sums (2 sums)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_quads[0] <= 16'd0;
            sum_quads[1] <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            sum_quads[0] <= sum_pairs[0] + sum_pairs[1];
            sum_quads[1] <= sum_pairs[2] + sum_pairs[3];
        end else begin
            sum_quads[0] <= 16'd0;
            sum_quads[1] <= 16'd0;
        end
    end

    // Stage 5: Final sum of the two sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum <= 16'd0;
        end else if (mul_en_pipe[3]) begin
            final_sum <= sum_quads[0] + sum_quads[1];
        end else begin
            final_sum <= 16'd0;
        end
    end

    // Output enable synchronized to final_sum valid
    assign mul_en_out = mul_en_pipe[3];

    // Output mux: valid final product or zero
    assign mul_out = mul_en_out ? final_sum : 16'd0;

endmodule