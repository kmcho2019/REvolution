module multi_pipe_4bit #(parameter size = 4)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire [size-1:0]      mul_a,
    input  wire [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);
    localparam product_width = 2*size;

    // Zero-extend multiplicand at MSB side by 'size' bits
    wire [product_width-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products: shifted multiplicand if mul_b bit is 1, else zero
    wire [product_width-1:0] partial [0:size-1];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial
            assign partial[i] = mul_b[i] ? (a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register each partial product individually for pipeline balancing
    reg [product_width-1:0] stage1_regs [0:size-1];
    integer idx;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (idx=0; idx<size; idx=idx+1)
                stage1_regs[idx] <= {product_width{1'b0}};
        end else begin
            for (idx=0; idx<size; idx=idx+1)
                stage1_regs[idx] <= partial[idx];
        end
    end

    // Stage 2: pairwise add partial products -> produces two sums (for size=4)
    reg [product_width-1:0] stage2_reg0, stage2_reg1;
    always @(posedge clk) begin
        if (!rst_n) begin
            stage2_reg0 <= {product_width{1'b0}};
            stage2_reg1 <= {product_width{1'b0}};
        end else begin
            // Add partial products pairwise
            stage2_reg0 <= stage1_regs[0] + stage1_regs[1];
            stage2_reg1 <= stage1_regs[2] + stage1_regs[3];
        end
    end

    // Stage 3: final addition of stage2 sums -> output product
    always @(posedge clk) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= stage2_reg0 + stage2_reg1;
    end

endmodule