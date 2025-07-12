module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding MSBs with zeros
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline Stage 1 registers: store each partial product
    reg [2*size-1:0] pp_reg [size-1:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j +1)
                pp_reg[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size; j = j +1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Pipeline Stage 2 registers: sum pairs of partial products and register
    reg [2*size-1:0] sum_pair0_reg, sum_pair1_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_pair0_reg <= {2*size{1'b0}};
            sum_pair1_reg <= {2*size{1'b0}};
        end else begin
            sum_pair0_reg <= pp_reg[0] + pp_reg[1];
            sum_pair1_reg <= pp_reg[2] + pp_reg[3];
        end
    end

    // Pipeline Stage 3 registers: sum the two partial sums and register final product
    reg [2*size-1:0] final_sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum_reg <= {2*size{1'b0}};
            mul_out      <= {2*size{1'b0}};
        end else begin
            final_sum_reg <= sum_pair0_reg + sum_pair1_reg;
            mul_out      <= final_sum_reg;
        end
    end

endmodule