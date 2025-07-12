module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand once to 2*size bits (zero-extended at MSBs)
    wire [2*size-1:0] extended_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    // partial_product[i] = extended_mul_a shifted left by i if mul_b[i]==1 else 0
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (extended_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 0: Register partial products to reduce combinational fanout and balance pipeline
    reg [2*size-1:0] pp_reg [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<size; j=j+1) pp_reg[j] <= {2*size{1'b0}};
        end else begin
            for (j=0; j<size; j=j+1) pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 1: Sum pairs of partial products, then register sums
    reg [2*size-1:0] sum_stage1_low, sum_stage1_high;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_low  <= {2*size{1'b0}};
            sum_stage1_high <= {2*size{1'b0}};
        end else begin
            sum_stage1_low  <= pp_reg[0] + pp_reg[1];
            sum_stage1_high <= pp_reg[2] + pp_reg[3];
        end
    end

    // Stage 2: Sum the two stage 1 sums, register final product
    reg [2*size-1:0] sum_stage2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            sum_stage2 <= sum_stage1_low + sum_stage1_high;
            mul_out    <= sum_stage2;
        end
    end

endmodule