module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        // Calculate partial product based on the corresponding bit in the multiplier
        always @(*) begin
            if (mul_b_ext[i] == 1'b1) begin
                partial_product[i] = mul_a_ext << i;
            end else begin
                partial_product[i] = {2*size{1'b0}};
            end
        end
    end
endgenerate

// Store intermediate sum values in registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= {2*size{1'b0}};
        sum_reg2 <= {2*size{1'b0}};
    end else begin
        sum_reg1 <= partial_product[0];
        for (int i = 1; i < size; i++) begin
            sum_reg1 <= sum_reg1 + partial_product[i];
        end
        sum_reg2 <= sum_reg1;
    end
end

// Calculate final product
assign mul_out = sum_reg2;

endmodule