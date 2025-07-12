module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] extended_mul_a;
reg [2*size-1:0] partial_sum;
reg [2*size-1:0] final_product;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        extended_mul_a <= {size{1'b0}} | mul_a;
        partial_sum <= {2*size{1'b0}};
        final_product <= {2*size{1'b0}};
    end else begin
        // Perform multiplication for each bit position of the multiplier
        reg [2*size-1:0] temp_sum;
        temp_sum = {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            if (mul_b[i] == 1'b1) begin
                temp_sum = temp_sum + (mul_a << i);
            end
        end
        partial_sum <= temp_sum;
    end
end

always @(posedge clk) begin
    if (rst_n) begin
        final_product <= partial_sum;
        mul_out <= final_product;
    end else begin
        final_product <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end
end

endmodule