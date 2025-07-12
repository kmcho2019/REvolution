module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    reg [7:0] partial_product [3:0];
    reg [7:0] sum;
    reg [7:0] intermediate_sum;
    integer i;

    // Initialize partial products
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (i = 0; i < 4; i++) begin
                partial_product[i] <= 8'd0;
            end
        end else begin
            for (i = 0; i < 4; i++) begin
                if (mul_b[i]) begin
                    partial_product[i] <= mul_a << i;
                end else begin
                    partial_product[i] <= 8'd0;
                end
            end
        end
    end

    // Calculate sum of partial products
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            sum <= 8'd0;
        end else begin
            sum <= 8'd0;
            for (i = 0; i < 4; i++) begin
                sum <= sum + partial_product[i];
            end
        end
    end

    // Store intermediate sum in a register
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            intermediate_sum <= 8'd0;
        end else begin
            intermediate_sum <= sum;
        end
    end

    // Output final product
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= intermediate_sum;
        end
    end

endmodule