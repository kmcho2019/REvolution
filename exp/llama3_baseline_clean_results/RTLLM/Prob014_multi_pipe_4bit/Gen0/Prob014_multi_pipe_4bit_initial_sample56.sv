module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    reg [2*size-1:0] partial_product [size-1:0];
    reg [2*size-1:0] sum_reg1, sum_reg2;
    wire [2*size-1:0] extended_mul_a;

    // Extend the input signals by adding zero bits at the most significant bit positions
    assign extended_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products using a generate block
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_product[i] <= 'd0;
                end else begin
                    if (mul_b[i]) begin
                        partial_product[i] <= extended_mul_a << i;
                    end else begin
                        partial_product[i] <= 'd0;
                    end
                end
            end
        end
    endgenerate

    // Add partial products using registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg1 <= 'd0;
        end else begin
            sum_reg1 <= partial_product[0] + partial_product[1] + partial_product[2] + partial_product[3];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg2 <= 'd0;
        end else begin
            sum_reg2 <= sum_reg1;
        end
    end

    // Calculate the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 'd0;
        end else begin
            mul_out <= sum_reg2;
        end
    end

endmodule