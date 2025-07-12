module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    // Register declaration
    reg [2*size-1:0] partial_product [size-1:0];
    reg [2*size-1:0] sum_reg;
    reg [2*size-1:0] final_product;

    // Multiplication using generate block
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                // Left shift the multiplicand by i positions
                assign partial_product[i] = { {size-i{1'b0}}, mul_a } << i;
            end else begin
                // Set the partial product to 0
                assign partial_product[i] = 'd0;
            end
        end
    endgenerate

    // Add partial products
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset condition
            sum_reg <= 'd0;
        end else begin
            // Update sum register
            sum_reg <= 'd0;
            for (int i = 0; i < size; i++) begin
                sum_reg <= sum_reg + partial_product[i];
            end
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // Reset condition
            final_product <= 'd0;
        end else begin
            // Update final product
            final_product <= sum_reg;
        end
    end

    // Output assignment
    assign mul_out = final_product;

endmodule