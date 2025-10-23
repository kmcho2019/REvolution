module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Pipeline register for enable signal (4 stages)
    reg [3:0] mul_en_pipe;

    // Input registers for operands
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires: each shifted according to multiplier bit index
    wire [15:0] partial_products[7:0];
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline registers for partial sums
    reg [15:0] sum_stage1_a; // sum of partial_products[0..3]
    reg [15:0] sum_stage1_b; // sum of partial_products[4..7]
    reg [15:0] sum_stage2;   // sum of above two sums
    reg [15:0] mul_out_reg;  // final output register

    // Stage 0 & 1: Sample inputs and generate partial sums for first half (0..3) and second half (4..7)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_pipe <= 4'd0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
            sum_stage1_a <= 16'd0;
            sum_stage1_b <= 16'd0;
        end else begin
            // Shift enable pipeline
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};

            // Sample inputs when enabled
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end

            // Calculate first partial sum group at stage 1 enable (mul_en_pipe[0])
            if (mul_en_pipe[0]) begin
                sum_stage1_a <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
                sum_stage1_b <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
            end else begin
                sum_stage1_a <= 16'd0;
                sum_stage1_b <= 16'd0;
            end
        end
    end

    // Stage 2: Sum the two partial sums from previous stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 16'd0;
        end else if (mul_en_pipe[1]) begin
            sum_stage2 <= sum_stage1_a + sum_stage1_b;
        end else begin
            sum_stage2 <= 16'd0;
        end
    end

    // Stage 3: Register the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out_reg <= 16'd0;
        end else if (mul_en_pipe[2]) begin
            mul_out_reg <= sum_stage2;
        end else begin
            mul_out_reg <= 16'd0;
        end
    end

    // Output enable derived from MSB of enable pipeline (stage 4)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
        end else begin
            mul_en_out <= mul_en_pipe[3];
        end
    end

    // Output product gated by output enable
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule