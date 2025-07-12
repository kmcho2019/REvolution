module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

// Extended input signals
wire [2*size-1:0] ext_mul_a = {size'd0, mul_a};
wire [2*size-1:0] ext_mul_b = {size'd0, mul_b};

// Partial products
wire [2*size-1:0] partial_product [size-1:0];

// Intermediate sum registers
reg [2*size-1:0] sum_reg1;
reg [2*size-1:0] sum_reg2;

// Generate block for partial products
genvar i;
generate
    for (i = 0; i < size; i++) begin
        if (ext_mul_b[i]) begin
            assign partial_product[i] = ext_mul_a << i;
        end else begin
            assign partial_product[i] = 'd0;
        end
    end
endgenerate

// Add partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg1 <= 'd0;
    end else begin
        sum_reg1 <= partial_product[0];
        for (int j = 1; j < size; j++) begin
            sum_reg1 <= sum_reg1 + partial_product[j];
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg2 <= 'd0;
    end else begin
        sum_reg2 <= sum_reg1;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule