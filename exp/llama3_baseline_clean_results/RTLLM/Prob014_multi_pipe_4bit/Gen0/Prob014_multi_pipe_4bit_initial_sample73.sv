module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

    // Extended input signals with size number of zero bits at the most significant bit positions
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

    // Registers to store intermediate sum values
    reg [2*size-1:0] partial_sum1;
    reg [2*size-1:0] partial_sum2;

    // Generate block to perform multiplication for each bit position of the multiplier
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin
            // Partial product calculation
            wire [2*size-1:0] partial_product = (mul_b_ext[i] == 1'b1) ? (mul_a_ext << i) : 'd0;

            // Add partial product to the intermediate sum
            always @(posedge clk or negedge rst_n) begin
                if (~rst_n) begin
                    partial_sum1 <= 'd0;
                end else begin
                    if (i == 0) begin
                        partial_sum1 <= partial_product;
                    end else begin
                        partial_sum1 <= partial_sum1 + partial_product;
                    end
                end
            end
        end
    endgenerate

    // Second level of pipeline to add partial sums
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            partial_sum2 <= 'd0;
        end else begin
            partial_sum2 <= partial_sum1;
        end
    end

    // Final product calculation
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= 'd0;
        end else begin
            mul_out <= partial_sum2;
        end
    end

endmodule