module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Internal signals
reg [2*size-1:0] partial_product [size-1:0];
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;
wire [2*size-1:0] sum_wire;

// Generate block for partial product calculation
genvar i;
generate
    for (i = 0; i < size; i++) begin
        always @(*) begin
            if (mul_b[i]) begin
                partial_product[i] = {size{1'b0}} << i;
                partial_product[i] = partial_product[i] | (mul_a << i);
            end else begin
                partial_product[i] = 'd0;
            end
        end
    end
endgenerate

// Add operation for partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 'd0;
        sum_reg2 <= 'd0;
    end else begin
        sum_reg1 <= partial_product[0];
        for (i = 1; i < size; i++) begin
            sum_reg2 <= sum_reg1 + partial_product[i];
            sum_reg1 <= sum_reg2;
        end
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule