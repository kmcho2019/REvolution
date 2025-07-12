module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

// Parameters
parameter size = 4;

// Intermediate signals
reg [7:0] partial_product [size-1:0];
reg [7:0] sum_reg1;
reg [7:0] sum_reg2;

// Extend input signals
reg [7:0] mul_a_ext;
reg [7:0] mul_b_ext;

// Extend input signals
always @(*) begin
    mul_a_ext = {4'd0, mul_a};
    mul_b_ext = {4'd0, mul_b};
end

// Generate partial products
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin
        always @(*) begin
            if (mul_b_ext[3-i] == 1'b1) begin
                partial_product[i] = mul_a_ext << i;
            end else begin
                partial_product[i] = 8'd0;
            end
        end
    end
endgenerate

// Update sum register 1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg1 <= 8'd0;
    end else begin
        sum_reg1 <= partial_product[0] + partial_product[1];
    end
end

// Update sum register 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg2 <= 8'd0;
    end else begin
        sum_reg2 <= sum_reg1 + partial_product[2] + partial_product[3];
    end
end

// Update product output
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 8'd0;
    end else begin
        mul_out <= sum_reg2;
    end
end

endmodule