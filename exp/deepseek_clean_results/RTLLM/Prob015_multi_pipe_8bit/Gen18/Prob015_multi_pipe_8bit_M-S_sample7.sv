module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] product_reg;
    reg [1:0] en_pipeline;

    // Partial products and sum (combinational)
    wire [15:0] partial_products [0:7];
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign partial_products[i] = b_reg[i] ? {8'b0, a_reg} << i : 16'b0;
        end
    endgenerate

    wire [15:0] sum = partial_products[0] + partial_products[1] + 
                      partial_products[2] + partial_products[3] + 
                      partial_products[4] + partial_products[5] + 
                      partial_products[6] + partial_products[7];

    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            product_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= mul_a;
            b_reg <= mul_b;
            
            // Stage 2: Register product
            product_reg <= sum;
            
            // Enable signal pipeline
            en_pipeline <= {en_pipeline[0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[1];
    assign mul_out = en_pipeline[1] ? product_reg : 16'b0;

endmodule