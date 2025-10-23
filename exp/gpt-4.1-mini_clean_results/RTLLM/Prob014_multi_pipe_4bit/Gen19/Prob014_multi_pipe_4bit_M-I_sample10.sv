module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,      // Active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Extend multiplicand by adding size zeros at MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally for each bit of mul_b
    wire [product_width-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : PARTIAL_PROD_GEN
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: latch all partial products
    reg [product_width-1:0] stage1_pp [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_pp[j] <= {product_width{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_pp[j] <= partial_products[j];
            end
        end
    end

    // Stage 2 accumulation logic with a 2-bit counter to control partial sum additions
    reg [1:0] acc_step;  // Accumulation step counter 0..3
    reg [product_width-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_step <= 2'b0;
            stage2_sum <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            case (acc_step)
                2'd0: begin
                    // Add partial_products[0] + partial_products[1]
                    stage2_sum <= stage1_pp[0] + stage1_pp[1];
                    mul_out <= mul_out;  // hold output
                    acc_step <= acc_step + 1'b1;
                end
                2'd1: begin
                    // Add previous sum + partial_products[2]
                    stage2_sum <= stage2_sum + stage1_pp[2];
                    mul_out <= mul_out; // hold output
                    acc_step <= acc_step + 1'b1;
                end
                2'd2: begin
                    // Add previous sum + partial_products[3]
                    stage2_sum <= stage2_sum + stage1_pp[3];
                    mul_out <= mul_out; // hold output
                    acc_step <= acc_step + 1'b1;
                end
                2'd3: begin
                    // Final product ready: output stage2_sum
                    mul_out <= stage2_sum;
                    // Start next accumulation cycle
                    acc_step <= 2'd0;
                end
                default: begin
                    acc_step <= 2'd0;
                    mul_out <= {product_width{1'b0}};
                    stage2_sum <= {product_width{1'b0}};
                end
            endcase
        end
    end

endmodule