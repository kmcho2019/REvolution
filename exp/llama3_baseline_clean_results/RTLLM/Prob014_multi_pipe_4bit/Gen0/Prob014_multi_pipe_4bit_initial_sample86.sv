module multi_pipe_4bit (
    input           clk,
    input           rst_n,
    input   [3:0]   mul_a,
    input   [3:0]   mul_b,
    output  [7:0]   mul_out
);

    parameter size = 4;

    reg   [7:0]   partial_product [0:size-1];
    reg   [7:0]   sum_reg1;
    reg   [7:0]   sum_reg2;

    // Generate block for partial product calculation
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    partial_product[i] <= 8'd0;
                end else begin
                    if (mul_b[i]) begin
                        partial_product[i] <= {4'd0, mul_a} << i;
                    end else begin
                        partial_product[i] <= 8'd0;
                    end
                end
            end
        end
    endgenerate

    // First stage of pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg1 <= 8'd0;
        end else begin
            sum_reg1 <= partial_product[0] + partial_product[1];
        end
    end

    // Second stage of pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg2 <= 8'd0;
        end else begin
            sum_reg2 <= sum_reg1 + partial_product[2] + partial_product[3];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= sum_reg2;
        end
    end

endmodule