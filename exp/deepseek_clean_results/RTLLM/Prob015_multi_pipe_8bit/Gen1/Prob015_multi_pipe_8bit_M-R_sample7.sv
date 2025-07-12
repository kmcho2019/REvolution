module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline control - 4 bits for 3 computation stages + input stage
    reg [3:0] enable_pipe;

    // Pipeline registers
    reg [7:0]  stage0_a, stage0_b;    // Input stage
    reg [15:0] stage1_pp [7:0];       // Stage 1: Partial products
    reg [15:0] stage2_sum [3:0];      // Stage 2: Intermediate sums
    reg [15:0] stage3_product;        // Stage 3: Final product

    // Generate properly aligned partial products (combinational)
    wire [15:0] pp [7:0];
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = ({8'b0, stage0_b[i] ? stage0_a : 8'b0}) << i;
        end
    endgenerate

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            enable_pipe <= 4'b0;
        end else begin
            enable_pipe <= {enable_pipe[2:0], mul_en_in};
        end
    end

    // Stage 0: Input sampling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage0_a <= 8'b0;
            stage0_b <= 8'b0;
        end else if (mul_en_in) begin
            stage0_a <= mul_a;
            stage0_b <= mul_b;
        end
    end

    // Stage 1: Partial product registration
    generate
        for (genvar j = 0; j < 8; j = j + 1) begin : pp_reg
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    stage1_pp[j] <= 16'b0;
                end else if (enable_pipe[0]) begin
                    stage1_pp[j] <= pp[j];
                end
            end
        end
    endgenerate

    // Stage 2: First level summation (balanced adder tree)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum[0] <= 16'b0;
            stage2_sum[1] <= 16'b0;
            stage2_sum[2] <= 16'b0;
            stage2_sum[3] <= 16'b0;
        end else if (enable_pipe[1]) begin
            stage2_sum[0] <= stage1_pp[0] + stage1_pp[1];
            stage2_sum[1] <= stage1_pp[2] + stage1_pp[3];
            stage2_sum[2] <= stage1_pp[4] + stage1_pp[5];
            stage2_sum[3] <= stage1_pp[6] + stage1_pp[7];
        end
    end

    // Stage 3: Final addition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_product <= 16'b0;
        end else if (enable_pipe[2]) begin
            stage3_product <= (stage2_sum[0] + stage2_sum[1]) + 
                             (stage2_sum[2] + stage2_sum[3]);
        end
    end

    // Output assignments
    assign mul_en_out = enable_pipe[3];
    assign mul_out = mul_en_out ? stage3_product : 16'b0;

endmodule