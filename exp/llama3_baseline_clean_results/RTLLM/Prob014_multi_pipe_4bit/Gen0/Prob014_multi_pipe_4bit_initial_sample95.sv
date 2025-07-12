module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    reg [2*size-1:0] partial_product [size-1:0];
    reg [2*size-1:0] sum_reg1, sum_reg2;

    // Extend input signals by adding "size" number of zero bits
    wire [2*size-1:0] extended_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] extended_mul_b = { {size{1'b0}}, mul_b };

    // Generate partial products for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    partial_product[i] <= 0;
                end else if (extended_mul_b[i]) begin
                    partial_product[i] <= extended_mul_a << i;
                end else begin
                    partial_product[i] <= 0;
                end
            end
        end
    endgenerate

    // Add partial products and store in sum_reg1
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg1 <= 0;
        end else begin
            sum_reg1 <= partial_product[0];
            for (i = 1; i < size; i++) begin
                sum_reg1 <= sum_reg1 + partial_product[i];
            end
        end
    end

    // Add sum_reg1 and store in sum_reg2 (pipeline stage)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum_reg2 <= 0;
        end else begin
            sum_reg2 <= sum_reg1;
        end
    end

    // Assign final product to output
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_reg2;
        end
    end

endmodule