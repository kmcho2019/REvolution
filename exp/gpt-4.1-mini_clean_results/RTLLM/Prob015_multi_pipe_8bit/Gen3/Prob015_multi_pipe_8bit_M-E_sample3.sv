module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Pipeline enable shift register (3 stages)
    reg [2:0] en_pipe;

    // Stage 1 input registers
    reg [7:0] a_reg_stage1, b_reg_stage1;

    // Split inputs into high and low 4 bits
    wire [3:0] a_low  = a_reg_stage1[3:0];
    wire [3:0] a_high = a_reg_stage1[7:4];
    wire [3:0] b_low  = b_reg_stage1[3:0];
    wire [3:0] b_high = b_reg_stage1[7:4];

    // Stage 1 partial products (4x4 multiplications)
    // These are combinational products based on registered inputs
    wire [7:0] p0 = a_low  * b_low;    // Product of lower 4 bits
    wire [7:0] p1 = a_low  * b_high;   // Mixed products
    wire [7:0] p2 = a_high * b_low;
    wire [7:0] p3 = a_high * b_high;

    // Stage 2 registers to hold partial sums
    reg [15:0] partial_sum_1;  // (p3 << 8) + ((p1 + p2) << 4)
    reg [15:0] partial_sum_0;  // p0

    // Stage 3 register holds final product sum
    reg [15:0] product_reg;

    // Update enable pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            en_pipe <= 3'b000;
        else
            en_pipe <= {en_pipe[1:0], mul_en_in};
    end

    // Stage 1: latch inputs when mul_en_in asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg_stage1 <= 8'd0;
            b_reg_stage1 <= 8'd0;
        end else if (mul_en_in) begin
            a_reg_stage1 <= mul_a;
            b_reg_stage1 <= mul_b;
        end
    end

    // Stage 2: compute partial sums and register them
    // p1 + p2 sum; shifts aligned; final shifted sums accumulated partially
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum_0 <= 16'd0;
            partial_sum_1 <= 16'd0;
        end else if (en_pipe[0]) begin
            partial_sum_0 <= {8'd0, p0}; // Lower product, zero-extended to 16 bits
            // (p1 + p2) shifted left 4 bits plus (p3 shifted left 8 bits)
            partial_sum_1 <= ({p3,8'd0}) + (((p1 + p2) << 4) & 16'hFFF0);
        end else begin
            partial_sum_0 <= 16'd0;
            partial_sum_1 <= 16'd0;
        end
    end

    // Stage 3: finalize product by adding the two partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product_reg <= 16'd0;
        else if (en_pipe[1])
            product_reg <= partial_sum_0 + partial_sum_1;
        else
            product_reg <= 16'd0;
    end

    // Output enable signal after last pipeline stage
    assign mul_en_out = en_pipe[2];

    // Output product: valid only when enabled
    assign mul_out = mul_en_out ? product_reg : 16'd0;

endmodule