module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,          // asynchronous active-low reset
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by size zeros at MSB
    // Extend mul_a and mul_b separately as specified
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Generate partial products: size partial products of width 2*size
    // For each bit of ext_mul_b from LSB to MSB, partial product is
    // if bit==1: ext_mul_a shifted by bit index, else zero
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = (ext_mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: Register all partial products
    reg [2*size-1:0] pp_reg [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 2 registers: sum pairs of partial products
    // sum0 = pp_reg[0] + pp_reg[1]
    // sum1 = pp_reg[2] + pp_reg[3]
    reg [2*size-1:0] sum_stage2_0, sum_stage2_1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2_0 <= {2*size{1'b0}};
            sum_stage2_1 <= {2*size{1'b0}};
        end else begin
            sum_stage2_0 <= pp_reg[0] + pp_reg[1];
            sum_stage2_1 <= pp_reg[2] + pp_reg[3];
        end
    end

    // Final output register: sum sums from stage 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= sum_stage2_0 + sum_stage2_1;
        end
    end

endmodule