module multi_pipe_4bit #(
    parameter size = 4
)(
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extend inputs by size zero bits at MSB side
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b }; // Extension not directly used but as per requirement

    // Partial products generation
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers to store intermediate sums
    // Split the partial products into two halves for two pipeline levels:
    // Level 1: sum of partial products 0 and 1
    // Level 2: sum of partial products 2 and 3
    // Then add the two sums in output stage

    reg [2*size-1:0] stage1_reg;
    reg [2*size-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= {2*size{1'b0}};
            stage2_reg <= {2*size{1'b0}};
        end else begin
            // Sum partial products 0 and 1
            stage1_reg <= partial_products[0] + partial_products[1];
            // Sum partial products 2 and 3
            stage2_reg <= partial_products[2] + partial_products[3];
        end
    end

    // Final product calculation stage with pipeline register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage1_reg + stage2_reg;
        end
    end

endmodule