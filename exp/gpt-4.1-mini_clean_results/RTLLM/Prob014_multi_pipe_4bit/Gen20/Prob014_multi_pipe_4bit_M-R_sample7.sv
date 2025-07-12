module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extended multiplicand with size zeros in MSB
    wire [(2*size)-1:0] ext_mul_a = { {(size){1'b0}}, mul_a };

    // Generate partial products combinationally (size partial products)
    wire [(2*size)-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Stage 1 registers: store partial products
    reg [(2*size)-1:0] pp_reg [size-1:0];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= {(2*size){1'b0}};
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                pp_reg[idx] <= partial_products[idx];
        end
    end

    // Stage 2 registers: sum partial products pairwise
    // For size=4, sum pairs: sum0 = pp_reg[0] + pp_reg[1], sum1 = pp_reg[2] + pp_reg[3]
    reg [(2*size)-1:0] sum_reg [1:0];
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg[0] <= {(2*size){1'b0}};
            sum_reg[1] <= {(2*size){1'b0}};
        end else begin
            sum_reg[0] <= pp_reg[0] + pp_reg[1];
            sum_reg[1] <= pp_reg[2] + pp_reg[3];
        end
    end

    // Stage 3 register: final sum and output register
    reg [(2*size)-1:0] final_sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum_reg <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            final_sum_reg <= sum_reg[0] + sum_reg[1];
            mul_out <= final_sum_reg;
        end
    end

endmodule