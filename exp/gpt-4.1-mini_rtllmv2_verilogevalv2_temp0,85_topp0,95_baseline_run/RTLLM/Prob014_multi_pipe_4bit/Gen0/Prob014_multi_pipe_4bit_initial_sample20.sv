module multi_pipe_4bit #(parameter size = 4)(
    input               clk,
    input               rst_n,
    input   [size-1:0]  mul_a,
    input   [size-1:0]  mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding size zeros at MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a }; // size zeros then mul_a
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = (mul_b[i]) ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline registers to store sums of pairs of partial products
    // We will sum partial_products[0]+partial_products[1], partial_products[2]+partial_products[3]
    // If size=4, this makes two sums at stage 1.
    reg [2*size-1:0] stage1_reg [0: (size/2)-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<(size/2); j=j+1) begin
                stage1_reg[j] <= {2*size{1'b0}};
            end
        end else begin
            // sum pairs
            for (j=0; j<(size/2); j=j+1) begin
                stage1_reg[j] <= partial_products[2*j] + partial_products[2*j+1];
            end
        end
    end

    // Second pipeline register sums the two stage1 registers to get final product
    reg [2*size-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= {2*size{1'b0}};
        end else begin
            stage2_reg <= stage1_reg[0] + stage1_reg[1];
        end
    end

    // Output register holds final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_reg;
        end
    end

endmodule