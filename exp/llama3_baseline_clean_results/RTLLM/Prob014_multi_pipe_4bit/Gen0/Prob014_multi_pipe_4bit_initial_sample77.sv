module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

    parameter size = 4;

    reg [7:0] partial_product [size];
    reg [7:0] intermediate_sum [size];
    reg [7:0] final_sum;

    // Extend input signals by adding "size" number of zero bits at the most significant bit positions
    wire [7:0] extended_mul_a = {4'd0, mul_a};

    // Generate block to perform multiplication for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i++) begin
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    partial_product[i] <= 8'd0;
                end else begin
                    if (mul_b[i]) begin
                        partial_product[i] <= extended_mul_a << i;
                    end else begin
                        partial_product[i] <= 8'd0;
                    end
                end
            end
        end
    endgenerate

    // Add of partial products using registers to store the intermediate sum values
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            intermediate_sum[0] <= 8'd0;
            intermediate_sum[1] <= 8'd0;
            intermediate_sum[2] <= 8'd0;
            intermediate_sum[3] <= 8'd0;
        end else begin
            intermediate_sum[0] <= partial_product[0];
            intermediate_sum[1] <= intermediate_sum[0] + partial_product[1];
            intermediate_sum[2] <= intermediate_sum[1] + partial_product[2];
            intermediate_sum[3] <= intermediate_sum[2] + partial_product[3];
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            final_sum <= 8'd0;
        end else begin
            final_sum <= intermediate_sum[3];
        end
    end

    // Update product output (mul_out)
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 8'd0;
        end else begin
            mul_out <= final_sum;
        end
    end

endmodule