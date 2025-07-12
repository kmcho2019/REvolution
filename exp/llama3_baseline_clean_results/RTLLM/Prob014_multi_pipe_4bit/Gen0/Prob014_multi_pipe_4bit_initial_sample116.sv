module multi_pipe_4bit(
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] reg1;
reg [7:0] reg2;

// Extend input signals by adding "size" number of zero bits at the most significant bit positions
wire [7:0] mul_a_ext = {4'd0, mul_a};
wire [7:0] mul_b_ext = {4'd0, mul_b};

// Generate block to perform multiplication for each bit position of the multiplier
genvar i;
generate
    for (i = 0; i < size; i++) begin
        wire [7:0] partial_product = (mul_b_ext[i] == 1'd1) ? (mul_a_ext << i) : 8'd0;
        if (i == 0) begin
            assign reg1 = partial_product;
        end else begin
            assign reg1 = reg1 + partial_product;
        end
    end
endgenerate

// Update registers with the sum of the corresponding partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        reg1 <= 8'd0;
        reg2 <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        reg2 <= reg1;
        mul_out <= reg2;
    end
end

endmodule